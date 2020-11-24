/* globals $ */

export default (selector) => {
  $(`${selector} [data-tooltip-title], ${selector} [data-tooltip-textonly]`).each((i, el) => {
    const content = {
      text() {
        return el.dataset.tooltipText;
      },
    };

    if (!el.dataset.tooltipTextonly) {
      content.title = () => el.dataset.tooltipTitle;
    }

    $(el).qtip({
      content,
      position: {
        target: 'mouse',
        my: 'bottom center',
        at: 'top center',
      },
    });
  });
};
