struct VertexOutput {
    @builtin(position) position: vec4f,
    @location(0) uv: vec2f,
};

@group(0) @binding(0) var<uniform> time: f32;

// Funkcije za šum (isti princip kao za dim)
fn hash(p: vec2f) -> f32 {
    return fract(sin(dot(p, vec2f(12.9898, 78.233))) * 43758.5453);
}

fn noise(p: vec2f) -> f32 {
    let i = floor(p);
    let f = fract(p);
    let u = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i + vec2f(0.0, 0.0)), hash(i + vec2f(1.0, 0.0)), u.x),
               mix(hash(i + vec2f(0.0, 1.0)), hash(i + vec2f(1.0, 1.0)), u.x), u.y);
}

fn fbm(p: vec2f) -> f32 {
    var v = 0.0;
    var a = 0.5;
    var p_mut = p;
    for (var i = 0; i < 4; i = i + 1) {
        v += a * noise(p_mut);
        p_mut = p_mut * 2.1;
        a *= 0.5;
    }
    return v;
}

@vertex
fn vertex_main(@builtin(vertex_index) VertexIndex : u32) -> VertexOutput {
    var pos = array<vec2f, 4>(
        vec2f(-0.5, -1.0), vec2f(0.5, -1.0),
        vec2f(-0.5, 1.0), vec2f(0.5, 1.0)
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
    // Pomeranje dima/plamena nagore
    let moving_uv = uv * vec2f(2.0, 1.0) - vec2f(0.0, time * 2.0);
    
    // Oblik plamena (sužava se ka vrhu)
    let shape = 1.0 - pow(abs(uv.x - 0.5) * 4.0, 2.0);
    let gradient = (1.0 - uv.y) * shape;
    
    // Generisanje vatre pomoću šuma
    let n = fbm(moving_uv * 3.0);
    let fire = n * gradient;
    
    // Bojenje vatre na osnovu intenziteta
    var color = vec3f(0.0);
    if (fire > 0.1) {
        color = mix(vec3f(0.5, 0.0, 0.0), vec3f(1.0, 0.2, 0.0), (fire - 0.1) * 2.0);
    }
    if (fire > 0.3) {
        color = mix(color, vec3f(1.0, 0.8, 0.0), (fire - 0.3) * 2.0);
    }
    if (fire > 0.5) {
        color = mix(color, vec3f(1.0, 1.0, 1.0), (fire - 0.5) * 2.0);
    }

    let alpha = clamp(fire * 5.0, 0.0, 1.0);
    return vec4f(color, alpha);
}
