export async function init() {
  if (!navigator.gpu) {
    throw new Error("WebGPU nije podržan u ovom browseru.");
  }

  const adapter = await navigator.gpu.requestAdapter();
  if (!adapter) {
    throw new Error("Nije pronađen GPU adapter.");
  }

  const device = await adapter.requestDevice();

  // Kreiranje canvas-a
  const canvas = document.querySelector("canvas") as HTMLCanvasElement;
  const context = canvas.getContext("webgpu") as GPUCanvasContext;

  const format = navigator.gpu.getPreferredCanvasFormat();
  context.configure({
    device: device,
    format: format,
    alphaMode: "premultiplied",
  });

  console.log("WebGPU spreman!");
  console.log("WebGPU spreman!");
}
