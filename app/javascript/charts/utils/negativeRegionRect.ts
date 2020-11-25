import type { ScaleLinear } from 'd3-scale';
import type { Transition } from 'd3-transition';
import { select } from 'd3-selection';

type ScaleFunc = ScaleLinear<number, number, never>;
type TransitionFunc = Transition<SVGRectElement, unknown, null, undefined>;
type Return = [SVGRectElement, (scale: ScaleFunc) => SVGRectElement];

/**
 * Takes a scale for the vertical axis and creates a <rect> which represents the part of the chart
 * whose values are less than zero.
 *
 * Returns a tuple containing the <rect> element and a function which can be called with a scale to
 * update the position and height of the rect.
 */
export default (width: number, yScale: ScaleFunc, attributes = {}): Return => {
  const el = document.createElementNS('http://www.w3.org/2000/svg', 'rect');

  const update = (yScale: ScaleFunc, transition?: TransitionFunc): SVGRectElement => {
    const d3el = select(el);

    d3el.transition(transition);
    d3el.attr('height', (yScale(yScale.domain()[0]) - yScale(0)).toString());
    d3el.attr('y', yScale(0).toString());

    return el;
  };

  el.classList.add('negative-region');
  el.setAttribute('width', width.toString());

  for (const [key, value] of Object.entries(attributes)) {
    el.setAttribute(key, value.toString());
  }

  update(yScale);

  return [el, update];
};
