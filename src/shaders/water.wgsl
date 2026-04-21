struct VertexOutput {
    @builtin(position) position: vec4f,
    @location(0) uv: vec2f,
};

@group(0) @binding(0) var<uniform> time: f32;

fn hash(p: vec2f) -> f32 {
    return fract(sin(dot(p, vec2f(127.1, 311.7))) * 43758.5453123);
}

fn noise(p: vec2f) -> f32 {
    let i = floor(p);
    let f = fract(p);
    let u = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i + vec2f(0.0, 0.0)), hash(i + vec2f(1.0, 0.0)), u.x),
               mix(hash(i + vec2f(0.0, 1.0)), hash(i + vec2f(1.0, 1.0)), u.x), u.y);
}

// FBM za detaljnije talase (mreškanje vode)
fn fbm(p: vec2f) -> f32 {
    var v = 0.0;
    var a = 0.5;
    var p_mut = p;
    for (var i = 0; i < 4; i = i + 1) {
        v += a * noise(p_mut);
        p_mut = p_mut * 2.0 + vec2f(10.0, 10.0);
        a *= 0.5;
    }
    return v;
}

@vertex
fn vertex_main(@builtin(vertex_index) VertexIndex : u32) -> VertexOutput {
    var pos = array<vec2f, 4>(
        vec2f(-1.0, -1.0), vec2f(1.0, -1.0),
        vec2f(-1.0, 1.0), vec2f(1.0, 1.0)
    );
    var uv = array<vec2f, 4>(
        vec2f(0.0, 1.0), vec2f(1.0, 1.0),
        vec2f(0.0, 0.0), vec2f(1.0, 0.0)
    );

    var output: VertexOutput;
    output.position = vec4f(pos[VertexIndex], 0.0, 1.0);
    output.uv = uv[VertexIndex];
    return output;
}

@fragment
fn fragment_main(@location(0) uv: vec2f) -> @location(0) vec4f {
    // Distorzija UV koordinata (mreškanje)
    let p = uv * 4.0;
    let t = time * 0.5;
    
    // Pravimo dva sloja talasa koji se kreću u suprotnim pravcima
    let n1 = fbm(p + t);
    let n2 = fbm(p - t * 0.8 + vec2f(5.0));
    
    let water_pattern = (n1 + n2) * 0.5;
    
    // Boje: od tamno plave do svetlo tirkizne
    let deep_blue = vec3f(0.0, 0.1, 0.4);
    let light_blue = vec3f(0.1, 0.5, 0.8);
    let foam_white = vec3f(0.8, 0.9, 1.0);
    
    var color = mix(deep_blue, light_blue, water_pattern);
    
    // Dodavanje "pjene" na vrhovima talasa
    if (water_pattern > 0.65) {
        color = mix(color, foam_white, (water_pattern - 0.65) * 3.0);
    }
    
    return vec4f(color, 1.0);
}
