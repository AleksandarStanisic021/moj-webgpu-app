// Struktura koja prenosi podatke iz Vertex u Fragment shader
struct VertexOutput {
    @builtin(position) clip_position: vec4f,
};

@vertex
fn vs_main(
    @builtin(vertex_index) in_vertex_index: u32
) -> VertexOutput {
    // Definišemo tri tačke trougla (X, Y)
    var pos = array<vec2f, 3>(
        vec2f(0.0, 0.5),    // Gornja tačka
        vec2f(-0.5, -0.5),  // Donja leva
        vec2f(0.5, -0.5)    // Donja desna
    );

    var out: VertexOutput;
    // Postavljamo Z na 0.0 i W na 1.0
    out.clip_position = vec4f(pos[in_vertex_index], 0.0, 1.0);
    return out;
}

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4f {
    // Vraća čistu crvenu boju (R, G, B, A)
    return vec4f(1.0, 0.0, 0.0, 1.0);
}
