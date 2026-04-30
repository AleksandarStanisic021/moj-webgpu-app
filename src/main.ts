// @ts-ignore
import "./style.css";
import { init } from "./init";
import { shader } from "./shader/shader.wgsl";

init().catch((error) => {
  console.error("Greška prilikom inicijalizacije WebGPU-a:", error);
});

const { device, context, format, adapter } = await init();

const pipeline: GPURenderPipeline = device.createRenderPipeline({
  layout: "auto",
  vertex: {
    module: device.createShaderModule({
      code: shader.vertex,
    }),
    entryPoint: "vs_main",
  },

  fragment: {
    module: device.createShaderModule({
      code: shader.fragment,
    }),
    entryPoint: "fs_main",
    targets: [{ format }],
  },
  primitive: {
    topology: "triangle-list",
  },
});

const commandEncoder = device.createCommandEncoder();
const textureView = context.getCurrentTexture().createView();

const renderPass = commandEncoder.beginRenderPass({
  colorAttachments: [
    {
      view: textureView,
      clearValue: { r: 0.0, g: 0.0, b: 0.0, a: 1.0 },
      loadOp: "clear",
      storeOp: "store",
    },
  ],
});

console.log(device, context, format, adapter);
