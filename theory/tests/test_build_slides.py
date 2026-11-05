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

    def test_workflow_builds_every_theme_in_selected_mode(self):
        check = '''import os, pathlib, subprocess, sys, tempfile, yaml
workflow = yaml.load(pathlib.Path(sys.argv[1]).read_text(), Loader=yaml.BaseLoader)
choice = workflow["on"]["workflow_dispatch"]["inputs"]["build_type"]
assert choice["type"] == "choice"
assert choice["options"] == ["draft", "final"]
steps = workflow["jobs"]["build"]["steps"]
step = next(step for step in steps if step.get("id") == "build")
assert step["env"]["BUILD_TYPE"] == "${{ inputs.build_type }}"
assert steps[-1]["with"]["path"] == "theory/builds/*.pdf"
assert steps[-1]["with"]["if-no-files-found"] == "error"
with tempfile.TemporaryDirectory() as directory:
    root = pathlib.Path(directory)
    (root / "various-themes").mkdir()
    for name in ("alpha", "beta"):
        (root / "various-themes" / (name + ".typ")).touch()
    binary = root / "uv"
    binary.write_text('#!/bin/sh\\nprintf "%s\\\\n" "$*" >> "$BUILD_LOG"\\n')
    binary.chmod(0o755)
    for mode in ("draft", "final", "invalid"):
        log = root / (mode + ".log")
        env = dict(os.environ, PATH=str(root) + os.pathsep + os.environ["PATH"],
                   BUILD_TYPE=mode, BUILD_LOG=str(log))
        result = subprocess.run(["bash", "-c", step["run"]], cwd=root, env=env,
                                capture_output=True, text=True)
        if mode == "invalid":
            assert result.returncode != 0
            assert not log.exists()
            continue
        assert result.returncode == 0, result.stderr
        suffix = " --draft" if mode == "draft" else ""
        assert log.read_text().splitlines() == [
            "run --script theory/build-slides.py " + theme + suffix
            for theme in ("standard", "clinical", "various-themes/alpha.typ", "various-themes/beta.typ")
        ]
'''
        result = subprocess.run(
            ["uv", "run", "--with", "pyyaml", "python", "-c", check,
             str(ROOT / ".github/workflows/build-theory.yml")],
            cwd=ROOT, capture_output=True, text=True,
        )
        self.assertEqual(result.returncode, 0, result.stderr)


if __name__ == "__main__":
    unittest.main()
