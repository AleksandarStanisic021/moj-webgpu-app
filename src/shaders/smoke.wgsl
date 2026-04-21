struct VertexOutput {
    @builtin(position) position: vec4f,
    @location(0) uv: vec2f,
};

@group(0) @binding(0) var<uniform> time: f32;

// Funkcija za generisanje nasumičnih vrednosti (Hash)
fn hash(p: vec2f) -> f32 {
    return fract(sin(dot(p, vec2f(127.1, 311.7))) * 43758.5453123);
}

// Jednostavan šum (Noise)
fn noise(p: vec2f) -> f32 {
    let i = floor(p);
    let f = fract(p);
    let u = f * f * (3.0 - 2.0 * f);

    return mix(mix(hash(i + vec2f(0.0, 0.0)), hash(i + vec2f(1.0, 0.0)), u.x),
               mix(hash(i + vec2f(0.0, 1.0)), hash(i + vec2f(1.0, 1.0)), u.x), u.y);
}

// Fraktalni šum (više slojeva šuma za "gustinu" dima)
fn fbm(p: vec2f) -> f32 {
    var v = 0.0;
    var a = 0.5;
    var shift = vec2f(100.0);
    var p_mut = p;
    for (var i = 0; i < 5; i = i + 1) {
        v += a * noise(p_mut);
        p_mut = p_mut * 2.0 + shift;
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
    // Pomeranje koordinata nagore tokom vremena
    let moving_uv = uv * 3.0 + vec2f(0.0, time * 0.5);
    
    // Generisanje dima
    let smoke_density = fbm(moving_uv);
    
    // Boja dima (siva/bela) sa providnošću
    let color = vec3f(0.8, 0.8, 0.8) * smoke_density;
    let alpha = smoke_density * (1.0 - uv.y); // Dim bledi pri vrhu ekrana
    
    return vec4f(color, alpha);
}
