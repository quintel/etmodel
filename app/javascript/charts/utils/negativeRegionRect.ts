import type { ScaleLinear } from 'd3-scale';

type ScaleFunc = ScaleLinear<number, number, never>;
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

  const update = (yScale: ScaleFunc): SVGRectElement => {
    el.setAttribute('height', (yScale(yScale.domain()[0]) - yScale(0)).toString());
    el.setAttribute('y', yScale(0).toString());

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
