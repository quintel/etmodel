/* globals $ */

export default selector => {
  $(`${selector} [data-tooltip-title]`).qtip({
    content: {
      title() {
        return $(this).attr('data-tooltip-title');
      },
      text() {
        return $(this).attr('data-tooltip-text');
      }
    },
    position: {
      target: 'mouse',
      my: 'bottom center',
      at: 'top center'
    }
  });
};
