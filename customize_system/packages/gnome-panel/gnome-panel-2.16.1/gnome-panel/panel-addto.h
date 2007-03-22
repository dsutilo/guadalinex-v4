/*
 * panel-addto.h:
 *
 * Copyright (C) 2004 Vincent Untz
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
 * 02111-1307, USA.
 *
 * Authors:
 *	Vincent Untz <vincent@vuntz.net>
 *	Manu Cornet <manu@manucornet.net>
 */

#ifndef __PANEL_ADDTO_H__
#define __PANEL_ADDTO_H__

G_BEGIN_DECLS

#include <libgnomecanvas/libgnomecanvas.h>
#include <libgnome/gnome-desktop-item.h>
#include <gconf/gconf-client.h>
#include <gdk/gdkkeysyms.h>
#include <gtk/gtk.h>
#include <atk/atk.h>

#include "menu.h"

#include "launcher.h"
#include "panel.h"
#include "drawer.h"
#include "panel-applet-frame.h"
#include "panel-action-button.h"
#include "panel-menu-bar.h"
#include "panel-separator.h"
#include "panel-toplevel.h"
#include "panel-menu-button.h"
#include "panel-globals.h"
#include "panel-lockdown.h"
#include "panel-util.h"
#include "panel-profile.h"

typedef struct PanelAddtoEntry PanelAddtoEntry;

typedef struct PanelAddtoInformation {
	GSList *categories;
	int n_categories;
} PanelAddtoInformation;

typedef struct {
	PanelWidget           *panel_widget;
	PanelAddtoInformation *info;

	GtkWidget          *addto_dialog;
	GtkWidget          *label;
	GtkWidget          *back_button;
	GtkWidget          *add_button;
	GtkWidget          *tree_view;
	GtkWidget          *canvas;
	GtkWidget          *applets_sw;
        GtkWidget          *applications_sw;
        GtkWidget          *inner_vbox;
        GtkWidget          *statuslabel;
        GtkWidget          *search_entry;
        GtkWidget          *search_label;
        GtkWidget          *launcher_button;
        GtkWidget          *custom_launcher_button;
        GtkCellRenderer    *renderer;
	GtkTreeModel       *applet_model;
	GtkTreeModel       *application_model;

	GMenuTree    *menu_tree;

	GSList       *applet_list;
	GSList       *application_list;
	GSList       *settings_list;
	guint         name_notify;
	int           insertion_position;

        gint status;
} PanelAddtoDialog;

enum {
        APPLETS,
        APPLICATIONS
};

typedef enum {
	PANEL_ADDTO_APPLET,
	PANEL_ADDTO_ACTION,
	PANEL_ADDTO_LAUNCHER_MENU,
	PANEL_ADDTO_LAUNCHER,
	PANEL_ADDTO_LAUNCHER_NEW,
	PANEL_ADDTO_MENU,
	PANEL_ADDTO_MENUBAR,
	PANEL_ADDTO_SEPARATOR,
	PANEL_ADDTO_DRAWER
} PanelAddtoItemType;


typedef struct PanelAddtoCategory {
	GSList *entries;
	int n_entries;

	char *title;
	char *english_title;

        gboolean translated;

	gpointer user_data;

	guint real_category : 1;
} PanelAddtoCategory;

typedef struct PanelAddtoItemInfo {
	PanelAddtoItemType       type;
	PanelActionButtonType    action_type;
	char                    *category;
	char                    *english_category;
	char                    *name;
	char                    *description;
	char                    *icon;
	char                    *launcher_path;
	char                    *menu_filename;
	char                    *menu_path;
	char                    *iid;
	gboolean                 static_data;
} PanelAddtoItemInfo;

struct PanelAddtoEntry {
	PanelAddtoCategory *category;
        PanelAddtoItemInfo *item_info;
	PanelAddtoDialog *dialog;

	char *title;
	char *comment;

	GdkPixbuf *icon_pixbuf;

	gpointer user_data;
};


typedef struct {
	GSList             *children;
	PanelAddtoItemInfo  item_info;
} PanelAddtoAppList;

void
panel_addto_dialog_response (GtkWidget *widget_dialog,
			     guint response_id,
			     PanelAddtoDialog *dialog);
gboolean panel_addto_add_item (PanelAddtoDialog   *dialog,
			       PanelAddtoItemInfo *item_info);
void panel_addto_debug_print  (PanelAddtoInformation *info);
void panel_addto_present      (GtkMenuItem *item,
                               PanelWidget *panel_widget);

G_END_DECLS

#endif /* __PANEL_ADDTO_H__ */
