interface BackwardsCompatChartView {
  prototype: {
    containerSelector(): string;
    container_selector(): string;
    createValueFormatter(): (value: number) => string;
    isEmpty(): boolean;
    is_empty(): boolean;
    main_formatter(): (value: number) => string;
    toggleFormat(): void;
    toggle_format(): void;
    updateLockIcon(): void;
    update_lock_icon(): void;
  };
}

/**
 * Takes a Chart class and adds methods to make it backwards compatible with snake_case used in
 * some parts of the old Sprockets-based code.
 *
 * Note this adds backwards-compatibility methods directly to the given class prototype; it does not
 * create a new class.
 */
export default (klass: BackwardsCompatChartView): BackwardsCompatChartView => {
  klass.prototype.container_selector = klass.prototype.containerSelector;
  klass.prototype.main_formatter = klass.prototype.createValueFormatter;
  klass.prototype.toggle_format = klass.prototype.toggleFormat;
  klass.prototype.update_lock_icon = klass.prototype.updateLockIcon;
  klass.prototype.is_empty = klass.prototype.isEmpty;

  return klass;
};
