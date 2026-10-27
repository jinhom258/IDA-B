# LWE estimator — GitHub Actions reproduction

Minimal repository for running `run_lwe.sage` on an Ubuntu GitHub runner.
No data, no manuscript, no credentials are included.

## 1. Create a GitHub repository

Create an empty repository (private is fine), e.g. `iadb-lwe-estimator`.

## 2. Push this directory

```bash
cd paper/lwe_estimator/github_repro
git init
git add .
git commit -m "lwe estimator reproduction"
git branch -M main
git remote add origin https://github.com/<user>/iadb-lwe-estimator.git
git push -u origin main
```

## 3. Run

GitHub → **Actions** → **lwe-estimator** → **Run workflow**.

The job installs SageMath and `lattice-estimator`, runs:

```bash
sage -python run_lwe.sage
```

and uploads `lwe_estimator_output.txt` as artifact `lwe-estimator-output`.

## 4. Bring the output back

Download the artifact and place the file at:

```
paper/lwe_estimator/lwe_estimator_output.txt
```

Then update `paper/lwe_estimator_results.json` from the actual stdout.
Do **not** keep the old 227.4/172.2 as verified if the rerun differs.

## 5. If `apt install sagemath` fails

Use a SageMath container instead:

```yaml
jobs:
  estimate:
    runs-on: ubuntu-latest
    container: sagemath/sagemath:latest
```

Then remove the `sudo apt-get ...` step and keep the `sage -pip` steps.
Do not silently ignore the failure.

## Expected outputs

For each `(n_short, sigma)` the script prints:

```
RESULT n=512 sigma=307.8
{... estimator dictionary ...}
```

The key question is whether the earlier numbers reproduce, and whether larger
sigma actually gives a higher security estimate (which would indicate a
parameter/labeling error).