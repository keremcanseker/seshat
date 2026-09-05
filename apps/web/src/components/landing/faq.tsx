"use client";

import { ChevronDown } from "lucide-react";
import { useEffect, useRef } from "react";

export type FaqItem = { q: string; a: string };

// Native <details> list with one shared hover plate. The plate does not blink
// from row to row: it appears under the row you enter, glides to the next one,
// and fades out where it is when the pointer leaves. Open/close height is
// animated in CSS (::details-content) where the browser supports it.
export function Faq({ items }: { items: FaqItem[] }) {
  const box = useRef<HTMLDivElement>(null);
  const plate = useRef<HTMLSpanElement>(null);

  useEffect(() => {
    const list = box.current;
    const hg = plate.current;
    if (!list || !hg) return;

    const still = matchMedia("(prefers-reduced-motion: reduce)");
    let lit = false;
    let target: HTMLElement | null = null;

    // `jump` writes the geometry without travel: on arrival from outside the
    // list, and on re-measures that are not pointer moves (resize, toggle).
    const place = (el: HTMLElement, jump: boolean) => {
      const b = list.getBoundingClientRect();
      const r = el.getBoundingClientRect();
      if (jump) hg.style.transition = "none";
      hg.style.width = `${r.width}px`;
      hg.style.height = `${r.height}px`;
      hg.style.transform = `translate3d(${r.left - b.left}px, ${r.top - b.top}px, 0)`;
      if (jump) {
        void hg.offsetWidth; // flush so the restored transition has nothing to animate
        hg.style.transition = "";
      }
      target = el;
    };
    const show = (el: HTMLElement) => {
      place(el, !lit || still.matches);
      if (!lit) {
        lit = true;
        hg.classList.add("is-on");
      }
    };
    const hide = () => {
      lit = false;
      hg.classList.remove("is-on");
    };
    const rowOf = (t: EventTarget | null) =>
      t instanceof Element ? t.closest<HTMLElement>("summary") : null;

    const onOver = (e: PointerEvent) => {
      if (e.pointerType === "touch") return;
      const el = rowOf(e.target);
      if (el) show(el);
    };
    const onFocusIn = (e: FocusEvent) => {
      const el = rowOf(e.target);
      if (el?.matches(":focus-visible")) show(el);
    };
    const onFocusOut = (e: FocusEvent) => {
      if (!(e.relatedTarget instanceof Node) || !list.contains(e.relatedTarget)) hide();
    };
    const remeasure = () => {
      if (lit && target?.isConnected) place(target, true);
    };

    list.addEventListener("pointerover", onOver);
    list.addEventListener("pointerleave", hide);
    list.addEventListener("focusin", onFocusIn);
    list.addEventListener("focusout", onFocusOut);
    list.addEventListener("toggle", remeasure, true);
    addEventListener("resize", remeasure);
    return () => {
      list.removeEventListener("pointerover", onOver);
      list.removeEventListener("pointerleave", hide);
      list.removeEventListener("focusin", onFocusIn);
      list.removeEventListener("focusout", onFocusOut);
      list.removeEventListener("toggle", remeasure, true);
      removeEventListener("resize", remeasure);
    };
  }, []);

  return (
    <div ref={box} className="faq">
      {items.map((it) => (
        <details key={it.q} className="faq-item">
          <summary>
            <span>{it.q}</span>
            <ChevronDown size={18} strokeWidth={2} aria-hidden />
          </summary>
          <div className="faq-a">
            <p>{it.a}</p>
          </div>
        </details>
      ))}
      <span ref={plate} className="faq-hg" aria-hidden />
    </div>
  );
}
