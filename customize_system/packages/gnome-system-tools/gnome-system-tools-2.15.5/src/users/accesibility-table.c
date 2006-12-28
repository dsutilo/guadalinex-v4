/* -*- Mode: C; tab-width: 8; indent-tabs-mode: t; c-basic-offset: 8 -*- */
/* accesibility-table.c: this file is part of users-admin, a ximian-setup-tool frontend 
 * for user administration.
 * 
 * Copyright (C) 2006 Álvaro Peña
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307, USA.
 *
 * Authors: Álvaro Peña <apg@openshin.com>
 */

#include <config.h>
#include "gst.h"
#include <glib/gi18n.h>
#include <string.h>
#include <stdlib.h>
#include "accesibility-table.h"

#define PROFILE_PATH "/etc/desktop-profiles"

extern GstTool *tool;

enum {
	COL_ACTIVATE,
	COL_PROFILE_NAME
};

static void on_accesibility_toggled (GtkCellRendererToggle *cell, gchar *path_str, gpointer data);
static void populate_accesibility_profiles (GtkTreeModel *model);

void
create_accesibility_table (void)
{
	GtkWidget *list;
	GtkTreeModel *model;
	GtkCellRenderer *renderer;
	GtkTreeViewColumn *column;
	GtkTreeIter iter;

	list = gst_dialog_get_widget (tool->main_dialog, "user_accesibility");

	model = GTK_TREE_MODEL (gtk_list_store_new (2, G_TYPE_BOOLEAN, G_TYPE_STRING));
	gtk_tree_view_set_model (GTK_TREE_VIEW (list), model);
	g_object_unref (model);

	column = gtk_tree_view_column_new ();

	renderer = gtk_cell_renderer_toggle_new ();
	gtk_tree_view_column_pack_start (column, renderer, FALSE);
	gtk_tree_view_column_set_attributes (column,
					     renderer,
					     "active", COL_ACTIVATE,
					     NULL);
	g_signal_connect (G_OBJECT (renderer), "toggled", G_CALLBACK (on_accesibility_toggled), model);

	renderer = gtk_cell_renderer_text_new ();
	gtk_tree_view_column_pack_end (column, renderer, TRUE);
	gtk_tree_view_column_set_attributes (column,
					     renderer,
					     "text", COL_PROFILE_NAME,
					     NULL);

	gtk_tree_view_column_set_sort_column_id (column, 1);
	gtk_tree_view_insert_column (GTK_TREE_VIEW (list), column, 0);
	gtk_tree_view_column_clicked (column);

	/* populate profiles */
	populate_accesibility_profiles (model);
}

static void
populate_accesibility_profiles (GtkTreeModel *model)
{
	GDir *profile_dir;
	gchar *current_file;
	gchar *profile_name;
	GtkTreeIter iter;
	
	if (!g_file_test (PROFILE_PATH, G_FILE_TEST_IS_DIR)) {
		g_print ("Error: can't found profile path in: %s", PROFILE_PATH);
		return;
	}
	
	profile_dir = g_dir_open (PROFILE_PATH, 0, NULL);
	
	current_file = g_dir_read_name (profile_dir);
	while (current_file != NULL) {
		if (g_str_has_suffix (current_file, "zip")) {
			profile_name = g_strndup (current_file, (strlen (current_file) - 4));
			gtk_list_store_append (GTK_LIST_STORE (model), &iter);
			gtk_list_store_set (GTK_LIST_STORE (model), &iter,
					    COL_ACTIVATE, FALSE,
					    COL_PROFILE_NAME, profile_name,
					    -1);
		}

		current_file = g_dir_read_name (profile_dir);
	}
}

static void
on_accesibility_toggled (GtkCellRendererToggle *cell, gchar *path_str, gpointer data)
{
	GtkTreeModel *model = (GtkTreeModel*) data;
	GtkTreePath  *path  = gtk_tree_path_new_from_string (path_str);
	GtkTreeIter   iter;
	gboolean      value;

	if (gtk_tree_model_get_iter (model, &iter, path)) {
		gtk_tree_model_get (model, &iter, 0, &value, -1);
		gtk_list_store_set (GTK_LIST_STORE (model), &iter, 0, !value, -1);
	}

	gtk_tree_path_free (path);
}

void
accessibility_table_save (gchar *user_name)
{
	GtkWidget *table;
	GtkTreeModel *model;
	GtkTreeIter iter;
	gchar *profile, *command_line;
	gboolean valid, apply;
	
	table = gst_dialog_get_widget (tool->main_dialog, "user_accesibility");
	model = gtk_tree_view_get_model (GTK_TREE_VIEW (table));
	valid = gtk_tree_model_get_iter_first (model, &iter);

	while (valid) {
		gtk_tree_model_get (model, &iter,
				    COL_ACTIVATE, &apply,
				    COL_PROFILE_NAME, &profile,
				    -1);
		if (apply) {
			command_line = g_strdup_printf ("/usr/bin/adp-admin.sh %s %s -f", user_name, profile);
			system (command_line);
		}
		
		valid = gtk_tree_model_iter_next (model, &iter);
	}
}
