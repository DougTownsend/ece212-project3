"""Draws the ADC control FSM state diagram to images/adc_fsm.png."""
from pathlib import Path

import matplotlib.pyplot as plt
from matplotlib.patches import Circle, FancyArrowPatch

OUT = Path(__file__).resolve().parent.parent / "adc_fsm.png"
R = 0.75

fig, ax = plt.subplots(figsize=(9, 7))
ax.set_xlim(-1.5, 8.5)
ax.set_ylim(-1.2, 6.8)
ax.set_aspect("equal")
ax.axis("off")

# Each state is drawn with its Moore outputs inside the circle
states = {
    "IDLE": ((1.0, 5.0), ""),
    "SETTLE": ((6.0, 5.0), ""),
    "INC": ((6.0, 0.5), "inc = 1"),
    "DONE": ((1.0, 0.5), "clr = 1\nload = 1"),
}
circles = {}
for name, ((x, y), outputs) in states.items():
    c = Circle((x, y), R, fc="#e8f0fa", ec="black", lw=1.5)
    ax.add_patch(c)
    circles[name] = c
    if outputs:
        ax.text(x, y + 0.2, name, ha="center", va="center", fontsize=13, family="monospace", weight="bold")
        ax.text(x, y - 0.3, outputs, ha="center", va="center", fontsize=10, family="monospace")
    else:
        ax.text(x, y, name, ha="center", va="center", fontsize=13, family="monospace", weight="bold")


def transition(a, b, label, label_pos, rad=0.0, ha="center"):
    ax.add_patch(FancyArrowPatch(states[a][0], states[b][0], patchA=circles[a], patchB=circles[b],
                                 connectionstyle=f"arc3,rad={rad}", arrowstyle="-|>",
                                 mutation_scale=18, lw=1.5, color="black"))
    ax.text(*label_pos, label, ha=ha, va="center", fontsize=11, family="monospace")


# Starting state
ax.add_patch(FancyArrowPatch((-1.0, 5.0), (1.0 - R, 5.0), arrowstyle="-|>", mutation_scale=18, lw=1.5, color="black"))
ax.text(-1.0, 5.25, "start here", ha="left", va="bottom", fontsize=10, style="italic")

# IDLE self loop
ax.add_patch(FancyArrowPatch((0.55, 5.6), (1.45, 5.6), connectionstyle="arc3,rad=-1.6",
                             arrowstyle="-|>", mutation_scale=18, lw=1.5, color="black"))
ax.text(1.0, 6.55, "start = 0", ha="center", va="center", fontsize=11, family="monospace")

# Each label is placed beside its edge, near the state the edge leaves from
transition("IDLE", "SETTLE", "start = 1", (1.9, 5.25), ha="left")
transition("SETTLE", "INC", "comp = 0 and\nmax = 0", (6.75, 3.7), rad=-0.3, ha="left")
transition("INC", "SETTLE", "always", (5.35, 1.6), rad=-0.3, ha="right")
transition("SETTLE", "DONE", "comp = 1 or\nmax = 1", (3.85, 4.4))
transition("DONE", "IDLE", "always", (1.15, 1.7), ha="left")

ax.text(3.5, -0.9, "Outputs not shown in a state are 0.", ha="center", fontsize=10, style="italic")

fig.savefig(OUT, dpi=150, bbox_inches="tight", facecolor="white")
print(f"Wrote {OUT}")
