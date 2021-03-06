/* Copyright (c) 2013-2020, MUSEN Development Team. All rights reserved.
   This file is part of MUSEN framework http://msolids.net/musen.
   See LICENSE file for license and warranty information. */
   
#version 130

uniform sampler2D u_texture;	// texture
uniform highp mat4 u_matrix_p;	// projection matrix

varying highp vec3 v_position;	// particle center position in eye space coordinates
varying highp vec4 v_color;		// color of particle
varying highp float v_radius;	// radius of particle

void main()
{
	highp vec3 normal;
	normal.xy = gl_PointCoord.xy * 2.0 - 1.0;
	highp float mag = dot(normal.xy, normal.xy);
	if (mag > 1.0) discard; // kill pixels outside circle
	normal.z = sqrt(1.0 - mag);

	// calculate depth
	highp vec4 pixelPos = u_matrix_p * vec4(v_position + normal * v_radius, 1.0);
	gl_FragDepth = pixelPos.z / pixelPos.w * 0.5 + 0.5; // [-1; 1] -> [0; 1]

	gl_FragColor = v_color * texture(u_texture, gl_PointCoord.xy);
};