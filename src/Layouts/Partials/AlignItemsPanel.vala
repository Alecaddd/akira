/*
 * Copyright (c) 2018 Alecaddd (http://alecaddd.com)
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public
 * License along with this program; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301 USA
 *
 * Authored by: Giacomo "giacomoalbe" Alberini <giacomoalbe@gmail.com>
 */
public class Akira.Layouts.Partials.AlignItemsPanel : Gtk.Grid {
  public weak Akira.Window window { get; construct; }

  private Gtk.Grid alignmentBox;
  private Gtk.Grid outerBox;


  public AlignItemsPanel (Akira.Window main_window) {
    Object(
      window: main_window,
      orientation: Gtk.Orientation.VERTICAL
    );
  }

  construct {
    vexpand = false;
    hexpand = true;

    outerBox = new Gtk.Grid ();

    outerBox.hexpand = true;
    outerBox.get_style_context ().add_class("alignment-box");

    alignmentBox = new Gtk.Grid ();
    alignmentBox.halign = Gtk.Align.CENTER;

    AlignBoxItem[] alignBoxItems = {
      AlignBoxItem("btn", "even-h", "distribute-horizontal-center", "Distribute centers evenly horizontally"),
      AlignBoxItem("btn", "even-v", "distribute-vertical-center", "Distribute center evenly vertically"),
      AlignBoxItem("sep"),
      AlignBoxItem("btn", "alig-h-l", "align-horizontal-left", "Align left sides"),
      AlignBoxItem("btn", "alig-h-c", "align-horizontal-center", "Center on horizontal axis"),
      AlignBoxItem("btn", "alig-h-r", "align-horizontal-right", "Align right sides"),
      AlignBoxItem("sep"),
      AlignBoxItem("btn", "alig-v-t", "align-vertical-top", "Align top sides"),
      AlignBoxItem("btn", "alig-v-c", "align-vertical-center", "Center on vertical axis"),
      AlignBoxItem("btn", "alig-v-b", "align-vertical-bottom", "Align bottom sides")
    };

    int loop = 0;

    foreach (var item in alignBoxItems) {
      switch (item.type) {
        case "sep":
          alignmentBox.attach ( new Gtk.Separator (Gtk.Orientation.VERTICAL), loop++, 0, 1, 1 );
          break;

        case "btn":
          var tmpAlignBoxButton = new Akira.Partials.AlignBoxButton (item.action, item.icon_name, item.title);

          tmpAlignBoxButton.triggered.connect (on_button_event);

          alignmentBox.attach (tmpAlignBoxButton, loop++, 0, 1, 1);
          break;
      }
    }

    outerBox.attach (alignmentBox, 1, 0, 1, 1);

    attach (outerBox, 1, 0, 1, 1);

    connect_signals();
  }

  private void update_icons_style(string icon_style) {
    alignmentBox.foreach((child) => {
      if (child is Akira.Partials.AlignBoxButton) {
        var button = (Akira.Partials.AlignBoxButton) child;

        button.change_icon_style();
      }
    });
  }

  private void connect_signals() {
    event_bus.update_icons_style.connect(() => {
      update_icons_style(settings.icon_style);
    });
  }

  private void on_button_event(Akira.Partials.AlignBoxButton button) {
    print ("Action Triggered: %s\n", button.action);
  }
}

class Akira.Partials.AlignBoxButton : Gtk.Grid {
  public string icon_name;
  public Gtk.IconSize icon_size;
  public string action;

  private Gtk.Button button;
  private Gtk.Image image;

  public signal void triggered(Akira.Partials.AlignBoxButton emitter);

  public AlignBoxButton(string action, string icon_name, string title, Gtk.IconSize icon_size = Gtk.IconSize.SMALL_TOOLBAR) {
    this.action = action;
    this.icon_name = icon_name;
    this.icon_size = icon_size;

    this.tooltip_text = title;

    can_focus = false;
    hexpand = true;

    image = new Gtk.Image.from_icon_name(this.get_icon_full_name(), icon_size);
    image.margin = 0;

    button = new Gtk.Button();
    button.can_focus = false;
    button.halign = Gtk.Align.CENTER;

    button.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
    button.get_style_context ().add_class ("button");

    button.add (image);

    attach (button, 0, 0, 1, 1);

    this.button.clicked.connect (() => {
      this.triggered (this);
    });
  }

  public void change_icon_style() {
    button.remove (image);

    image = new Gtk.Image.from_icon_name (this.get_icon_full_name (), this.icon_size);

    button.add (image);
    image.show_all ();
  }

  public string get_icon_full_name() {
    var icon_full_name = "";
    //this.icon_size = Gtk.IconSize.LARGE_TOOLBAR;

    switch (settings.icon_style) {
      case "filled":
        icon_full_name = this.icon_name;
        break;
      case "lineart":
        icon_full_name = this.icon_name;
        break;
      case "symbolic":
        icon_full_name = this.icon_name + "-symbolic";
        break;
    }

    return icon_full_name;
  }
}

struct AlignBoxItem {
  public string type;
  public string icon_name;
  public string action;
  public string title;

  public AlignBoxItem(string type, string action = "", string icon_name = "", string title = "") {
    this.type = type;
    this.action = action;
    this.icon_name = icon_name;
    this.title = title;
  }
}