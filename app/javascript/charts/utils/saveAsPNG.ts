import html2canvas from 'html2canvas';

/**
 * Builds a subheader to be shown below the chart title, containing the scenario dataset, end year,
 * and title.
 */
const buildScenarioInfo = (): HTMLHeadingElement => {
  const header = document.createElement('h4');
  header.textContent = `${App.settings.get('area_name')} ${App.settings.get('end_year')}`;

  const scenarioName = App.settings.get('active_scenario_title') as string | null;

  if (scenarioName) {
    const title = document.createElement('span');
    title.classList.add('scenario-title');
    title.textContent = scenarioName;

    header.append(title);
  }

  return header;
};

/**
 * Saves an HTMLDivElement - which contains a chart - as a PNG.
 */
const saveAsPNG = (holder: HTMLDivElement): Promise<HTMLCanvasElement> => {
  const title = holder.querySelector('header h3').textContent;

  // Clone the chart - rather than operating directly on the visible chart - as this allows us to
  // adjust styles (add watermark, remove shadows) without the user noticing the changes to the
  // on-screen chart.
  const clone = holder.cloneNode(true) as HTMLDivElement;
  clone.removeAttribute('data-holder_id');
  clone.classList.add('html2canvas');

  holder.parentNode.insertBefore(clone, holder.nextSibling);

  clone.querySelector('header').append(buildScenarioInfo());

  const promise = html2canvas(clone, {
    scale: 2,
    scrollX: -window.scrollX,
    scrollY: -window.scrollY,
  });

  promise.then((canvas) => {
    clone.remove();

    const link = document.createElement('a');

    link.download = title;
    link.href = canvas.toDataURL();
    link.click();
  });

  return promise;
};

/**
 * Event which may be attached to a button or anchor to trigger downloading a chart.
 */
export const onClick = (event: MouseEvent): void => {
  event.preventDefault();

  const target = event.target as HTMLAnchorElement;
  saveAsPNG(target.closest('.chart_holder') as HTMLDivElement);
};

export default saveAsPNG;
