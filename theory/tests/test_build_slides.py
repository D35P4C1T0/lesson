import subprocess
import tempfile
import unittest
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SCRIPT = ROOT / "theory/build-slides.py"


class BuildSlidesTest(unittest.TestCase):
    def test_speech_map_covers_every_slide(self):
        content = (ROOT / "theory/src/content.typ").read_text()
        speech = (ROOT / "theory/speech/ecream_draft1.md").read_text()
        slide_count = len(re.findall(r'^\s*#slide\("', content, re.MULTILINE)) + 1
        ranges = re.findall(r"Part (\d+) → (\d+)(?:–(\d+))?", speech)
        self.assertEqual([part for part, _, _ in ranges], list("1234"))
        covered = [1]
        for _, start, end in ranges:
            covered.extend(range(int(start), int(end or start) + 1))
        self.assertEqual(covered, list(range(1, slide_count + 1)))
        titles = re.findall(r'^\s*#slide\("([^"]+)"', content, re.MULTILINE)
        spoken = re.findall(r'\*\*Slide (\d+) — (.*?)\*\*', speech)
        self.assertEqual(spoken, [(str(index), title) for index, title in enumerate(titles, start=2)])

    def test_active_and_saved_themes_from_another_directory(self):
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "slides.pdf"
            saved_themes = [str(path.relative_to(ROOT)) for path in sorted((ROOT / "various-themes").glob("*.typ"))]
            for theme in ("standard", "clinical", *saved_themes):
                result = subprocess.run(
                    [str(SCRIPT), theme, "-o", str(output)],
                    cwd=directory, capture_output=True, text=True,
                )
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertTrue(output.read_bytes().startswith(b"%PDF"))

    def test_default_outputs_are_in_builds(self):
        for theme, filename in (("standard", "ecream_standard_slides.pdf"), ("clinical", "ecream_swiss_slides.pdf"), ("soft-play", "ecream-soft-play.pdf")):
            result = subprocess.run([str(SCRIPT), theme], cwd=ROOT, capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            output = ROOT / "theory/builds" / filename
            self.assertEqual(result.stdout.strip(), str(output))
            self.assertTrue(output.read_bytes().startswith(b"%PDF"))

    def test_draft_watermark_is_optional_and_has_requested_opacity(self):
        with tempfile.TemporaryDirectory() as directory:
            outputs = [Path(directory) / name for name in ("normal.pdf", "draft.pdf")]
            for output, flags in zip(outputs, ([], ["--draft"])):
                result = subprocess.run(
                    [str(SCRIPT), "soft-play", *flags, "-o", str(output)],
                    cwd=ROOT, capture_output=True, text=True,
                )
                self.assertEqual(result.returncode, 0, result.stderr)
            check = '''import sys, pymupdf
normal, draft = [pymupdf.open(name) for name in sys.argv[1:]]
assert len(normal) == len(draft)
assert all("DRAFT" not in page.get_text() for page in normal)
for page in draft:
    stamps = [span for span in page.get_texttrace()
              if "".join(chr(char[0]) for char in span["chars"]) == "DRAFT"]
    assert len(stamps) == 1
    stamp = stamps[0]
    assert abs(stamp["opacity"] - 0.2) < 0.0001
    box = pymupdf.Rect(stamp["bbox"])
    assert page.rect.contains(box)
    assert box.x0 < page.rect.width * 0.05
    assert box.y0 > page.rect.height * 0.95
'''
            result = subprocess.run(
                ["uv", "run", "--with", "pymupdf", "python", "-c", check, *map(str, outputs)],
                cwd=ROOT, capture_output=True, text=True,
            )
            self.assertEqual(result.returncode, 0, result.stderr)

    def test_invalid_theme_preserves_existing_output(self):
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "slides.pdf"
            output.write_bytes(b"existing export")
            result = subprocess.run(
                [str(SCRIPT), "missing-theme", "-o", str(output)],
                cwd=directory, capture_output=True, text=True,
            )
            self.assertNotEqual(result.returncode, 0)
            self.assertIn("Theme not found", result.stderr)
            self.assertEqual(output.read_bytes(), b"existing export")

    def test_workflows_select_themes_and_build_modes(self):
        check = r'''import os, pathlib, subprocess, sys, tempfile, yaml
repo = pathlib.Path(sys.argv[1])
options = ["standard", "clinical"] + sorted(p.stem for p in (repo / "various-themes").glob("*.typ")) + ["all"]
for lesson in (False, True):
    filename = "build-slides.yml" if lesson else "build-theory.yml"
    workflow = yaml.load((repo / ".github/workflows" / filename).read_text(), Loader=yaml.BaseLoader)
    choices = workflow["on"]["workflow_dispatch"]["inputs"]
    assert choices["build_type"]["options"] == ["draft", "final"]
    assert choices["theme"]["options"] == options
    assert choices["theme"]["default"] == "standard"
    assert choices["theme"]["type"] == "choice"
    steps = workflow["jobs"]["build"]["steps"]
    step = next(step for step in steps if step.get("id") == "build")
    assert steps[-1]["with"]["if-no-files-found"] == "error"
    if lesson:
        assert step["env"]["THEME"] == "${{ inputs.theme || 'standard' }}"
        assert step["env"]["BUILD_TYPE"] == "${{ inputs.build_type || 'final' }}"
        assert steps[-1]["with"]["path"] == "theory/builds/lesson-*.pdf"
    else:
        assert steps[-1]["with"]["path"] == "theory/builds/ecream*.pdf"
    with tempfile.TemporaryDirectory() as directory:
        root = pathlib.Path(directory)
        (root / "various-themes").mkdir()
        for name in ("alpha", "beta"):
            (root / "various-themes" / (name + ".typ")).touch()
        binary = root / "uv"
        binary.write_text('#!/bin/sh\nprintf "%s\\n" "$*" >> "$BUILD_LOG"\n')
        binary.chmod(0o755)
        for mode in ("draft", "final", "invalid"):
            for selected in ("standard", "soft-play", "all"):
                log = root / (mode + selected + ".log")
                env = dict(os.environ, PATH=str(root) + os.pathsep + os.environ["PATH"],
                           BUILD_TYPE=mode, THEME=selected, BUILD_LOG=str(log))
                result = subprocess.run(["bash", "-c", step["run"]], cwd=root, env=env,
                                        capture_output=True, text=True)
                if mode == "invalid":
                    assert result.returncode != 0
                    assert not log.exists()
                    continue
                assert result.returncode == 0, result.stderr
                suffix = " --lesson" if lesson else ""
                suffix += " --draft" if mode == "draft" else ""
                themes = ("standard", "clinical", "various-themes/alpha.typ", "various-themes/beta.typ") if selected == "all" else (selected,)
                assert log.read_text().splitlines() == [
                    "run --script theory/build-slides.py " + theme + suffix for theme in themes
                ]
'''
        result = subprocess.run(
            ["uv", "run", "--with", "pyyaml", "python", "-c", check, str(ROOT)],
            cwd=ROOT, capture_output=True, text=True,
        )
        self.assertEqual(result.returncode, 0, result.stderr)

    def test_complete_lesson_supports_selected_themes(self):
        with tempfile.TemporaryDirectory() as directory:
            for theme in ("standard", "soft-play"):
                result = subprocess.run(
                    [str(SCRIPT), theme, "--lesson", "--draft", "-o", str(Path(directory) / (theme + ".pdf"))],
                    cwd=directory, capture_output=True, text=True,
                )
                self.assertEqual(result.returncode, 0, result.stderr)
            check = '''import pathlib, pymupdf, sys
root = pathlib.Path(sys.argv[1])
for name in ("standard", "soft-play"):
    doc = pymupdf.open(root / (name + ".pdf"))
    theory = next(page for page in doc if "Identity and access" in page.get_text())
    fonts = {font[3] for font in theory.get_fonts()}
    assert any(("LibertinusSans" if name == "standard" else "Nunito") in font for font in fonts), fonts
    exercise = next(page for page in doc if "Ex 1" in page.get_text() and "Theory" not in page.get_text())
    assert any("LibertinusSans" in font[3] for font in exercise.get_fonts())
    assert all("DRAFT" in page.get_text() for page in doc)
'''
            result = subprocess.run(
                ["uv", "run", "--with", "pymupdf", "python", "-c", check, directory],
                cwd=ROOT, capture_output=True, text=True,
            )
            self.assertEqual(result.returncode, 0, result.stderr)


if __name__ == "__main__":
    unittest.main()
