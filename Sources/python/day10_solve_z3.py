import sys
from z3 import *

# === ЧТЕНИЕ ВХОДА ===
data = sys.stdin.read().strip().splitlines()

buttons = []
targets = []

mode = "buttons"

for line in data:
    line = line.strip()
    if not line:
        continue
    if line == "---":
        mode = "targets"
        continue

    if mode == "buttons":
        # строка вида "1,3,4"
        nums = [int(x) for x in line.split(",") if x]
        buttons.append(nums)
    else:
        # только одна строка: "14,22,181,..."
        targets = [int(x) for x in line.split(",") if x]

# === Z3 MODEL ===

num_buttons = len(buttons)
num_sections = len(targets)

x = [Int(f"x{i+1}") for i in range(num_buttons)]

solver = Optimize()

# x_i >= 0
for xi in x:
    solver.add(xi >= 0)

# constraints: sum(x_k for k covering section i) = targets[i]
for sec in range(num_sections):
    expr = []
    for idx, btn in enumerate(buttons):
        if sec in btn:
            expr.append(x[idx])
    solver.add(sum(expr) == targets[sec])

# minimize sum(x)
objective = solver.minimize(sum(x))

# solve
if solver.check() != sat:
    print("-1")
    sys.exit(0)

model = solver.model()
total = sum(model[xi].as_long() for xi in x)

print(total)
