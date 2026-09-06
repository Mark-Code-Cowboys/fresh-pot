#!/usr/bin/env python3
"""Regenerates assets/icon/*.png — the Fresh Pot placeholder mark:
a coffee pot with rising steam on roast brown #5C3A21.
Run from the repo root, then `dart run flutter_launcher_icons`."""
from PIL import Image, ImageDraw

BROWN = (92, 58, 33, 255)
CREAM = (240, 233, 221, 255)
WHITE = (255, 255, 255, 255)

def draw_glyph(d, s, ox=0, oy=0):
    def R(x0, y0, x1, y1, r, fill):
        d.rounded_rectangle([ox+x0*s, oy+y0*s, ox+x1*s, oy+y1*s],
                            radius=r*s, fill=fill)
    # Pot body (slightly tapered look via two stacked rounds).
    R(0.30, 0.42, 0.70, 0.80, 0.06, WHITE)
    R(0.33, 0.36, 0.67, 0.46, 0.03, WHITE)
    # Lid knob.
    d.ellipse([ox+0.46*s, oy+0.30*s, ox+0.54*s, oy+0.38*s], fill=WHITE)
    # Spout.
    d.polygon([(ox+0.30*s, oy+0.46*s), (ox+0.18*s, oy+0.52*s),
               (ox+0.30*s, oy+0.58*s)], fill=WHITE)
    # Handle.
    d.arc([ox+0.62*s, oy+0.46*s, ox+0.86*s, oy+0.72*s],
          start=-70, end=110, fill=WHITE, width=max(1, int(0.045*s)))
    # Two steam wisps.
    for cx in (0.42, 0.56):
        d.arc([ox+(cx-0.035)*s, oy+0.12*s, ox+(cx+0.035)*s, oy+0.20*s],
              start=90, end=270, fill=CREAM, width=max(1, int(0.03*s)))
        d.arc([ox+(cx-0.035)*s, oy+0.18*s, ox+(cx+0.035)*s, oy+0.26*s],
              start=-90, end=90, fill=CREAM, width=max(1, int(0.03*s)))

img = Image.new('RGBA', (1024, 1024), BROWN)
draw_glyph(ImageDraw.Draw(img), 1024)
img.save('assets/icon/icon.png')

fg = Image.new('RGBA', (1024, 1024), (0, 0, 0, 0))
draw_glyph(ImageDraw.Draw(fg), 640, ox=192, oy=192)
fg.save('assets/icon/icon_foreground.png')
print('icons written')
