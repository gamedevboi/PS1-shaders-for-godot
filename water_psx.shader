shader_type spatial; 
render_mode skip_vertex_transform, diffuse_burley,  cull_disabled; 

//Albedo texture 
uniform sampler2D albedoTex : hint_albedo; //Geometric resolution for vert sna[ 
uniform float snapRes = 8.0; 
uniform float roughness = 1.0;
uniform float specular = 0.1;
uniform float apha = 0.8;
uniform vec2 uv_scale = vec2(1.0, 1.0);
uniform vec2 uv_offset = vec2(.0, .0);
//How much light sources affect it
uniform float light_intensity = 0.3;

//Speed of flow: 1 is the standard, below 1 the flow is slower and above faster, negatives will meake it flow backwards
uniform float Flow_speed = 1.0;
// Speed of wave: how fast is the wave moving side by side, as before 1 is standard
uniform float Wave_speed = 1.0;
//vec4 for UV recalculation 
varying vec4 vertCoord; 
void vertex() { 
	UV = UV * uv_scale + uv_offset;
	VERTEX = (MODELVIEW_MATRIX * vec4(VERTEX, 1.0)).xyz; 
	VERTEX.xyz = floor(VERTEX.xyz * snapRes) / snapRes; 
	vertCoord = vec4(UV * VERTEX.x, VERTEX.z, 0); 
} 
void fragment() { 
	
	ROUGHNESS =roughness;
	SPECULAR = specular;
	
	//motion of water
	vec2 coord = UV * 1.0;
	//If you want more amplitud for the wave just change the 0.01 value
	vec2 motion = vec2(0.01*cos(Wave_speed * TIME), Flow_speed*TIME);
	
	ALBEDO = (texture(albedoTex, UV + motion).rgb);
	ALPHA = apha; 
	
	
	}
//QUICK FIX TO LIGHTING
void light()
{
	
	DIFFUSE_LIGHT = ALBEDO*LIGHT_COLOR*ATTENUATION*light_intensity;

}