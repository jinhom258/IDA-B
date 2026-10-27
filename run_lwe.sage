# -*- coding: utf-8 -*-
"""LWE estimator reproduction script for IAD-B.

Run on Kali with SageMath + lattice-estimator:

    sage -python run_lwe.sage | tee lwe_estimator_output.txt

This is intentionally small: the only purpose is to make the archived
227.4/172.2 numbers reproducible (or to show that they are wrong).
"""
from __future__ import annotations

import json
import sys

from estimator import LWE, ND  # noqa: F401

Q = 8380417
M = 1024
NS = [512, 384, 256]
SIGMAS = [307.8, 135.9]


def main():
    print("q=%d m=%d Xs=UniformMod(q) Xe=DiscreteGaussian(sigma)" % (Q, M))
    for n in NS:
        for sigma in SIGMAS:
            params = LWE.Parameters(
                n=n,
                q=Q,
                Xs=ND.UniformMod(Q),
                Xe=ND.DiscreteGaussian(sigma),
                m=M,
            )
            try:
                res = LWE.estimate(params, deny=["arora-gb"])
            except TypeError:
                # Older/newer API compatibility: retry without deny.
                res = LWE.estimate(params)
            print("RESULT n=%d sigma=%.1f" % (n, sigma))
            print(repr(res))
            print(json.dumps({"n": n, "sigma": sigma,
                              "result": {str(k): str(v) for k, v in res.items()}},
                             ensure_ascii=False))
            sys.stdout.flush()


if __name__ == "__main__":
    main()