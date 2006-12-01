/* -*- Mode: C; tab-width: 8; indent-tabs-mode: t; c-basic-offset: 8 -*- */
/* synce_string.h 
 * Copyright (C) 2006 Ghe Rivero <ghernando@yaco.es>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */

#ifndef __SYNCE_STRING_H__
#define __SYNCE_STRING_H__

char * stolower (char * str)
{
	int i = 0;

	for (i=0; str[i]; ++i)
		str[i] = tolower(str[ i ]);
	return str;
}

#endif /* __EGG_TRAY_ICON_H__ */
