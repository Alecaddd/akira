/**
 * Copyright (c) 2021 Alecaddd (https://alecaddd.com)
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
 * Authored by: Martin "mbfraga" Fraga <mbfraga@gmail.com>
 */


/*
 * ItemInsertMode handles item insertion. After the first click, this mode will use static methods
 * in the TransformMode to transform the inserted items.
 *
 * In the future, this mode can be kept alive during multiple clicks when inserting items like polylines.
 */
public class Akira.Lib2.Modes.ItemInsertMode : AbstractInteractionMode {
    public weak Akira.Lib2.ViewCanvas view_canvas { get; construct; }
    public weak Akira.Lib2.Managers.ModeManager mode_manager { get; construct; }

    private string item_insert_type;

    private Akira.Lib2.Modes.TransformMode transform_mode;

    public ItemInsertMode (
        Akira.Lib2.ViewCanvas canvas,
        Akira.Lib2.Managers.ModeManager mode_manager,
        string item_type
    ) {
        Object (
            view_canvas: canvas,
            mode_manager : mode_manager
        );

        item_insert_type = item_type;
    }

    construct {
        transform_mode = null;
    }

    public override AbstractInteractionMode.ModeType mode_type () { return AbstractInteractionMode.ModeType.ITEM_INSERT; }

    public override void mode_end () {
        if (transform_mode != null) {
            transform_mode.mode_end ();
        }
    }

    public override Gdk.CursorType? cursor_type () {
        if (transform_mode != null) {
            return transform_mode.cursor_type ();
        }

        return Gdk.CursorType.CROSSHAIR;
    }

    public override bool key_press_event (Gdk.EventKey event) {
        if (transform_mode != null) {
            return transform_mode.key_press_event (event);
        }
        return false;
    }

    public override bool key_release_event (Gdk.EventKey event) {
        if (transform_mode != null) {
            return transform_mode.key_press_event (event);
        }
        return false;
     }

    public override bool button_press_event (Gdk.EventButton event) {
        if (transform_mode != null) {
            return transform_mode.button_press_event (event);
        }

        if (event.button == Gdk.BUTTON_PRIMARY) {
            /*
            var sel_manager = canvas.selected_bound_manager;
            sel_manager.reset_selection ();

            var new_item = canvas.window.items_manager.insert_item (event.x, event.y);

            sel_manager.add_item_to_selection (new_item);

            canvas.nob_manager.selected_nob = Managers.NobManager.Nob.BOTTOM_RIGHT;
            canvas.update_canvas ();

            */
            var item = construct_item (item_insert_type, event.x, event.y);

            view_canvas.items_manager.add_item_to_canvas (item);

            view_canvas.selection_manager.reset_selection (item);

            transform_mode = new Akira.Lib2.Modes.TransformMode (view_canvas, null);
            transform_mode.mode_begin ();
            transform_mode.button_press_event (event);

            return true;
        }

        return false;
    }

    public override bool button_release_event (Gdk.EventButton event) {
        if (transform_mode != null) {
            transform_mode.button_release_event (event);
            mode_manager.deregister_mode (mode_type ());
        }

        return true;
    }

    public override bool motion_notify_event (Gdk.EventMotion event) {
        if (transform_mode != null) {
            return transform_mode.motion_notify_event (event);
        }

        return true;
    }

    public override Object? extra_context () {
        if (transform_mode != null) {
            return transform_mode.extra_context ();
        }

        return null;
    }

    private static Lib2.Items.ModelItem construct_item (string from_type, double x, double y)
    {
        var coordinates = new Lib2.Components.Coordinates (x, y);
        var size = new Lib2.Components.Size (50.0, 50.0, false);

        Lib2.Items.ModelItem new_item = null;
        switch (from_type) {
            case "rectangle":
                new_item = new Lib2.Items.ModelRect (
                    coordinates,
                    size,
                    borders_from_settings (),
                    fills_from_settings ()
                );
                break;

            case "ellipse":
                new_item = new Lib2.Items.ModelEllipse (
                    coordinates,
                    size,
                    borders_from_settings (),
                    fills_from_settings ()
                );
                break;

            case "text":
                new_item = new Lib2.Items.ModelRect (
                    coordinates,
                    size,
                    borders_from_settings (),
                    fills_from_settings ()
                );
                new_item.components.rotation = new Lib2.Components.Rotation(30);
                break;

            case "artboard":
                break;

            case "image":
                break;
        }

        if (new_item == null) {
            new_item = new Lib2.Items.ModelRect (
                coordinates,
                size,
                borders_from_settings (),
                fills_from_settings ()
            );
        }

        return new_item;
    }

    private static Lib2.Components.Fills fills_from_settings () {
        var fill_rgba = Gdk.RGBA ();
        fill_rgba.parse (settings.fill_color);
        return Lib2.Components.Fills.single_color(Lib2.Components.Color.from_rgba (fill_rgba));
    }

    private static Lib2.Components.Borders? borders_from_settings () {
        if (!settings.set_border) {
            return null;
        }

        var border_rgba = Gdk.RGBA ();
        border_rgba.parse (settings.border_color);
        return Lib2.Components.Borders.single_color (
            Lib2.Components.Color.from_rgba (border_rgba),
            settings.border_size
        );
    }
}