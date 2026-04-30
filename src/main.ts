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
      code: shader,
    }),
    entryPoint: "vs_main",
  },

  fragment: {
    module: device.createShaderModule({
      code: shader,
    }),
    entryPoint: "fs_main",
    targets: [{ format }],
  },
  primitive: {
    topology: "triangle-list",
  },
});

console.log(device, context, format, adapter);
