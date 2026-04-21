import "./style.css";
import { init } from "./init";
import Dog from "./dog";

const myDog = new Dog("Rex");
myDog.bark();

init().catch((error) => {
  console.error("Greška prilikom inicijalizacije WebGPU-a:", error);
});
