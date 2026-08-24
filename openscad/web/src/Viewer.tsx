import { useEffect, useRef } from "react";
import * as THREE from "three";
import { OrbitControls } from "three/examples/jsm/controls/OrbitControls.js";
import { STLLoader } from "three/examples/jsm/loaders/STLLoader.js";

export function Viewer({ stl }: { stl: ArrayBuffer | null }) {
  const host = useRef<HTMLDivElement>(null);
  const ctx = useRef<{
    renderer: THREE.WebGLRenderer;
    scene: THREE.Scene;
    camera: THREE.PerspectiveCamera;
    controls: OrbitControls;
    mesh?: THREE.Mesh;
    grid?: THREE.GridHelper;
    frame: number;
  } | null>(null);

  useEffect(() => {
    const el = host.current;
    if (!el) return;
    const scene = new THREE.Scene();
    scene.background = new THREE.Color(0x1b1e24);
    const camera = new THREE.PerspectiveCamera(45, 1, 0.1, 5000);
    camera.position.set(180, 140, 220);
    const renderer = new THREE.WebGLRenderer({ antialias: true });
    renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
    el.appendChild(renderer.domElement);
    const controls = new OrbitControls(camera, renderer.domElement);
    controls.enableDamping = true;
    scene.add(new THREE.AmbientLight(0xffffff, 0.55));
    const key = new THREE.DirectionalLight(0xffffff, 0.9);
    key.position.set(80, 160, 120);
    scene.add(key);
    scene.add(new THREE.HemisphereLight(0x9ec9ff, 0x334155, 0.35));
    const grid = new THREE.GridHelper(400, 20, 0x3d4450, 0x2a3038);
    scene.add(grid);

    const tick = () => {
      controls.update();
      renderer.render(scene, camera);
      rec.frame = requestAnimationFrame(tick);
    };
    const rec = { renderer, scene, camera, controls, grid, frame: 0 };
    ctx.current = rec;
    const resize = () => {
      const w = el.clientWidth || 1;
      const h = el.clientHeight || 1;
      camera.aspect = w / h;
      camera.updateProjectionMatrix();
      renderer.setSize(w, h);
    };
    resize();
    const ro = new ResizeObserver(resize);
    ro.observe(el);
    rec.frame = requestAnimationFrame(tick);
    return () => {
      cancelAnimationFrame(rec.frame);
      ro.disconnect();
      controls.dispose();
      renderer.dispose();
      renderer.domElement.remove();
      ctx.current = null;
    };
  }, []);

  useEffect(() => {
    const rec = ctx.current;
    if (!rec || !stl) return;
    if (rec.mesh) {
      rec.scene.remove(rec.mesh);
      rec.mesh.geometry.dispose();
      (rec.mesh.material as THREE.Material).dispose();
      rec.mesh = undefined;
    }
    const geom = new STLLoader().parse(stl);
    geom.computeVertexNormals();
    geom.computeBoundingBox();
    const bb = geom.boundingBox!;
    geom.translate(
      -(bb.min.x + bb.max.x) / 2,
      -(bb.min.y + bb.max.y) / 2,
      -bb.min.z
    );
    const mat = new THREE.MeshStandardMaterial({
      color: 0xd97757,
      metalness: 0.05,
      roughness: 0.45,
    });
    const mesh = new THREE.Mesh(geom, mat);
    mesh.rotation.x = -Math.PI / 2;
    rec.scene.add(mesh);
    rec.mesh = mesh;
    geom.computeBoundingBox();
    const size = geom.boundingBox!.getSize(new THREE.Vector3());
    const span = Math.max(size.x, size.y, 40);
    const height = size.z;
    if (rec.grid) {
      rec.scene.remove(rec.grid);
      rec.grid.geometry.dispose();
      const gmat = rec.grid.material;
      if (Array.isArray(gmat)) gmat.forEach((m) => m.dispose());
      else gmat.dispose();
    }
    const gridSize = Math.ceil(span * 2.4 / 20) * 20;
    rec.grid = new THREE.GridHelper(gridSize, 20, 0x3d4450, 0x2a3038);
    rec.scene.add(rec.grid);
    rec.camera.position.set(span * 1.4, height * 0.55 + span * 0.7, span * 1.5);
    rec.controls.target.set(0, height / 2, 0);
    rec.controls.update();
  }, [stl]);

  return <div className="viewer" ref={host} />;
}
