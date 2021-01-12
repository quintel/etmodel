/**
 * Builds a function which will translate keys and values used to display information about an
 * attached curve.
 */
export default (curveType: string) => {
  return (id: string, data?: { defaults?: { scope: string }[] }): string => {
    const defaultKey = 'custom_curves.' + id;
    let defaultScope = [{ scope: defaultKey }];

    if (id.slice(0, 5) === 'areas') {
      return I18n.t(id);
    }

    if (curveType) {
      if (data && data.defaults) {
        defaultScope = defaultScope.concat(data.defaults);
      }

      return I18n.t(
        'custom_curves.' + curveType + '.' + id,
        $.extend({}, data, {
          defaults: defaultScope,
        })
      );
    }

    return I18n.t(defaultKey);
  };
};
