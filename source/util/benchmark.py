# refer:https://blog.amedama.jp/entry/nvidia-smi-gpu-power-limit

import torch
import torch.utils.benchmark as benchmark


def batched_dot_bmm(a, b):
    '''Computes batched dot by reducing to bmm'''
    a = a.reshape(-1, 1, a.shape[-1])
    b = b.reshape(-1, b.shape[-1], 1)
    return torch.bmm(a, b).flatten(-3)


# Input for benchmarking
x = torch.randn(100000, 10000, device='cuda')


t = benchmark.Timer(
    stmt='batched_dot_bmm(x, x)',
    setup='from __main__ import batched_dot_bmm',
    globals={'x': x},
)

print(t.timeit(1000))
