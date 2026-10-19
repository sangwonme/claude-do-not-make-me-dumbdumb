# PoC/

One folder per core-logic experiment, created with `/poc new <name>`.

- `README.md` in each folder is yours: the question, your prediction, and your conclusion. Claude never edits it.
- Claude writes the experiment code, its check, `fixtures/`, and `result.md` (facts from each run).
- PoCs never import from `Codes/` or each other. Logic from `Codes/` is replaced by a small stand-in with recorded data.
- Everything runs in the same Docker image as `Codes/`.
- Merged or dropped PoCs stay here, frozen, as a record.
