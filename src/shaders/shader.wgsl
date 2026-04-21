struct VertexOutput {
    @builtin(position) position: vec4f,
    @location(0) color: vec4f,
};

@group(0) @binding(0) var<uniform> time: f32;

@vertex
fn vertex_main(
    @location(0) pos: vec2f,
    @location(1) color: vec3f
) -> VertexOutput {
    var output: VertexOutput;
    

    let s = sin(time);
    let c = cos(time);
    let rotatedPos = vec2f(
        pos.x * c - pos.y * s,
        pos.x * s + pos.y * c
    );

    output.position = vec4f(rotatedPos, 0.0, 1.0);
    output.color = vec4f(color, 1.0);
    
    return output;
}

@fragment
fn fragment_main(@location(0) color: vec4f) -> @location(0) vec4f {
    return color;
}
