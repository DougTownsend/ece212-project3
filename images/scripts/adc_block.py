"""Draws the ADC block diagram (adc_ctrl and adc_dp) to images/adc_block.png."""
from pathlib import Path

import matplotlib.pyplot as plt
from matplotlib.patches import FancyArrowPatch, FancyBboxPatch

OUT = Path(__file__).resolve().parent.parent / "adc_block.png"

fig, ax = plt.subplots(figsize=(9, 4))
ax.set_xlim(0, 9)
ax.set_ylim(0, 4)
ax.set_aspect("equal")
ax.axis("off")


def box(x, y, w, h, title, subtitle):
    ax.add_patch(FancyBboxPatch((x, y), w, h, boxstyle="round,pad=0.02,rounding_size=0.1",
                                fc="#e8f0fa", ec="black", lw=1.5))
    ax.text(x + w / 2, y + h / 2 + 0.15, title, ha="center", va="center",
            fontsize=14, family="monospace", weight="bold")
    ax.text(x + w / 2, y + h / 2 - 0.25, subtitle, ha="center", va="center", fontsize=11)


def arrow(start, end, label=None, label_pos=None, ha="center"):
    ax.add_patch(FancyArrowPatch(start, end, arrowstyle="-|>", mutation_scale=15, lw=1.5, color="black"))
    if label:
        ax.text(*label_pos, label, ha=ha, va="center", fontsize=12, family="monospace")


# Blocks
CTRL = (1.2, 1.0, 2.4, 1.6)
DP = (5.0, 1.0, 2.4, 1.6)
box(*CTRL, "adc_ctrl", "(control FSM)")
box(*DP, "adc_dp", "(datapath)")

# Inputs to the FSM
arrow((1.8, 3.6), (1.8, 2.6), "start", (1.8, 3.8))
arrow((3.0, 3.6), (3.0, 2.6), "comp", (3.0, 3.8))

# Control signals from the FSM to the datapath
for y, name in [(2.25, "inc"), (1.95, "clr"), (1.65, "load")]:
    arrow((3.6, y), (5.0, y), name, (4.3, y + 0.12))

# Status signal from the datapath back to the FSM
arrow((5.0, 1.25), (3.6, 1.25), "max", (4.3, 1.37))

# Datapath outputs
arrow((7.4, 2.1), (8.3, 2.1), "dac[4:0]", (7.45, 2.3), ha="left")
arrow((7.4, 1.5), (8.3, 1.5), "result[3:0]", (7.45, 1.7), ha="left")

# Clock to both blocks
ax.plot([2.4, 2.4, 6.2], [0.3, 0.3, 0.3], color="black", lw=1.5)
arrow((2.4, 0.3), (2.4, 1.0))
arrow((6.2, 0.3), (6.2, 1.0))
ax.plot([0.9, 2.4], [0.3, 0.3], color="black", lw=1.5)
ax.text(0.8, 0.3, "clk", ha="right", va="center", fontsize=12, family="monospace")

fig.savefig(OUT, dpi=150, bbox_inches="tight", facecolor="white")
print(f"Wrote {OUT}")
