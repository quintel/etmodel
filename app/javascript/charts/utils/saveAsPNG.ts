import html2canvas from 'html2canvas';

/**
 * Determines whether the current browser supports rendering to SVG without (major) issues.
 */
export const isSupported =
  // Safari has issues applying styles to SVG elements:
  // https://github.com/niklasvh/html2canvas/issues/2476
  //
  // Chrome/Chromium includes the substring "Safari" in their userAgent:
  // https://developer.mozilla.org/en-US/docs/Web/HTTP/Browser_detection_using_the_user_agent#browser_name
  !window.navigator.userAgent.includes('Safari/') || window.navigator.userAgent.includes('Chrom');

/**
 * Saves an HTMLDivElement - which contains a chart - as a PNG.
 */
const saveAsPNG = (holder: HTMLDivElement, scenarioID: number): Promise<HTMLCanvasElement> => {
  const title = holder.querySelector('header h3').textContent;

  // Clone the chart - rather than operating directly on the visible chart - as this allows us to
  // adjust styles (add watermark, remove shadows) without the user noticing the changes to the
  // on-screen chart.
  const clone = holder.cloneNode(true) as HTMLDivElement;
  clone.removeAttribute('data-holder_id');
  clone.classList.add('html2canvas');

  if (isHiDPI() && window.navigator.userAgent.includes('Firefox')) {
    // Add a class which reverts the clone to use Helvetica/Arial. As of 2021-03-01 rendering the
    // system font to Canvas in Firefox on a HiDPI screen causes uneven letter spacing.
    clone.classList.add('firefox-hidpi');
  }

  holder.parentNode.insertBefore(clone, holder.nextSibling);

  const promise = html2canvas(clone, {
    scale: 2,
    scrollX: -window.scrollX,
    scrollY: -window.scrollY,
  });

  promise.then((canvas) => {
    clone.remove();

    const link = document.createElement('a');

    link.download = `${title}.${scenarioID}.png`;
    link.href = canvas.toDataURL();
    link.click();
  });

  return promise;
};

/**
 * Detects a HiDPI display.
 */
const isHiDPI = () => {
  const mediaQuery =
    '(-webkit-min-device-pixel-ratio: 1.5),\
            (min--moz-device-pixel-ratio: 1.5),\
            (-o-min-device-pixel-ratio: 3/2),\
            (min-resolution: 1.5dppx)';

  if (window.devicePixelRatio > 1) return true;
  if (window.matchMedia && window.matchMedia(mediaQuery).matches) return true;

  return false;
};

/**
 * Event which may be attached to a button or anchor to trigger downloading a chart.
 */
export const onClick = (event: MouseEvent, scenarioID: number): void => {
  event.preventDefault();

  const target = event.target as HTMLAnchorElement;
  saveAsPNG(target.closest('.chart_holder') as HTMLDivElement, scenarioID);
};

/**
 * Provide isSupported on the onClick for easier access.
 */
onClick.isSupported = isSupported;

export default saveAsPNG;
