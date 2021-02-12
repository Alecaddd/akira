/**
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
 * Authored by: Alessandro "Alecaddd" Castellani <castellani.ale@gmail.com>
 */

using Akira.Lib.Components;

/**
 * Generate a simple Rectangle.
 */
public class Akira.Lib.Items.CanvasEllipse : Goo.CanvasEllipse, Akira.Lib.Items.CanvasItem {
    public Gee.ArrayList<Component> components { get; set; }

    public Items.CanvasArtboard? artboard { get; set; }

    public bool is_loaded { get; set; }

    public CanvasEllipse (
        double _center_x,
        double _center_y,
        double _radius_x,
        double _radius_y,
        int border_size,
        Gdk.RGBA border_color,
        Gdk.RGBA fill_color,
        Goo.CanvasItem? _parent,
        Items.CanvasArtboard? _artboard,
        bool _loaded
    ) {
        parent = _artboard != null ? _artboard : _parent;
        artboard = _artboard;
        canvas = parent.get_canvas () as Akira.Lib.Canvas;

        // Create the ellipse.
        width = height = 1;
        radius_x = radius_y = 0.0;
        // The Ellipse has a weird 0.5 value always attached to it on creation.
        center_x = center_y = - 0.5;

        // Add all the components that this item uses.
        components = new Gee.ArrayList<Component> ();
        components.add (new Components.Type (typeof (CanvasEllipse)));
        // Only the Name component needs the class to be passed on construct.
        // All the other components after this will inherit the class from the
        // main Component.
        components.add (new Name (this));
        components.add (new Transform ());
        components.add (new Opacity ());
        components.add (new Rotation ());
        components.add (new Fills (fill_color));
        components.add (new Borders (border_color, border_size));
        components.add (new Size ());
        components.add (new Flipped ());
        components.add (new BorderRadius ());
        components.add (new Layer ());

        // Add extra attributes.
        is_loaded = _is_loaded;
    }
}
