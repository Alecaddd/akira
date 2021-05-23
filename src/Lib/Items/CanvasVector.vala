/*
 * Copyright (c) 2019-2021 Alecaddd (https://alecaddd.com)
 *
 * This file is part of Akira.
 *
 * Akira is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.

 * Akira is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.

 * You should have received a copy of the GNU General Public License
 * along with Akira. If not, see <https://www.gnu.org/licenses/>.
 *
 * Authored by: Abdallah "Abdallah-Moh" Mohammad <abdallah.mam2007@gmail.com.com>
*/

using Akira.Lib.Components;

/*
 * Generate a simple Ellipse.
*/
public class Akira.Lib.Items.CanvasVector : Goo.CanvasPath, Lib.Items.CanvasItem {
    public Gee.ArrayList<Component> components { get; set; }

    public Items.CanvasArtboard? artboard { get; set; }

    public CanvasVector (
        double _x,
        double _y,
        int line_width,
        bool is_curved,
        Gdk.RGBA fill_color,
        Goo.CanvasItem? _parent,
        Items.CanvasArtboard? _artboard
    ) {
        parent = _artboard != null ? _artboard : _parent;
        artboard = _artboard;

        init_position(this, _x, _y);

        // Create Vector Items
        data = "M 0 0 C 20 20, 40 20, 50 0";
        this.fill_color = null;
        this.stroke_color = "#fff";

        // Add the newly created item to the Canvas or Artboard.
        parent.add_child (this, -1);

        // Force the generation of the item bounds on creation.
        Goo.CanvasBounds bounds;
        this.get_bounds (out bounds);

        // Add all the components that this item uses.
        components = new Gee.ArrayList<Component> ();
        components.add (new Name (this));
        components.add (new Coordinates (this));
        components.add (new Opacity (this));
        components.add (new Rotation (this));
        components.add (new Fills (this, fill_color));
        components.add (new Size (this));
        components.add (new Flipped (this));
        components.add (new Layer ());

        check_add_to_artboard (this);
    }
}
