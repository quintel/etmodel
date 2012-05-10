// vim: set sw=4 ts=4 et:

QUnit.specify('', function () {

    describe('setValue', function () {
        var wrapper = $('#slider'), slider;

        after(function () {
            wrapper.html('');
        });

        describe('when setting a value', function () {
            before(function () {
                slider = new $.Quinn(wrapper);
                slider.setValue(50);
            });

            it('should set the new value', function () {
                assert(slider.model.value).equals(50);
            });

            it('should not permit values larger than the selectable range', function () {
                assert(slider.setValue(101)).equals(100);
                assert(slider.model.value).equals(100);
            });

            it('should not permit values smaller than the selectable range', function () {
                assert(slider.setValue(-1)).equals(0);
                assert(slider.model.value).equals(0);
            });

            it('should run the drag callback', function () {
                var dragRun = false;

                slider = new $.Quinn(wrapper, {
                    drag: function () {
                        dragRun = true;
                    }
                });

                slider.setValue(50);
                assert(dragRun).isTrue();
            });

            it('should run the change callback', function () {
                var changeRun = false;

                slider = new $.Quinn(wrapper, {
                    change: function () {
                        changeRun = true;
                    }
                });

                slider.setValue(50);
                assert(changeRun).isTrue();
            });
        }); // when setting a value

        describe('when the slider is disabled', function () {
            before(function () {
                slider = new $.Quinn(wrapper, { disable: true });
            });

            it('should not change the slider value', function () {
                assert(slider.setValue(50)).equals(false)
                assert(slider.model.value).equals(0);
            });
        }); // when the slider is disabled

        describe('when given no argument', function () {
            before(function () {
                slider = new $.Quinn(wrapper, { value: 50 });
            });

            it('should do nothing', function () {
                assert(slider.setValue()).equals(50);
                assert(slider.model.value).equals(50);
            });
        }); // when given no argument

        describe('when the value does not match the step', function () {
            before(function () {
                slider = new $.Quinn(wrapper, { step: 7 });
            });

            it('should round to the nearest step', function () {
                var values = [ 0, 6, 7, 8, 9, 10, 11 ],
                    rounds = [ 0, 7, 7, 7, 7,  7, 14 ],
                    rounded;

                rounded = _.map(values, function (value) {
                    slider.setValue(value);
                    return slider.model.value;
                });

                assert(rounded).isSameAs(rounds);
            });
        }); // when the value does not match the step

        describe('when the drag callback returns false', function () {
            var changeRun;

            before(function () {
                slider = new $.Quinn(wrapper, {
                    drag:   function () { return false },
                    change: function () { changeRun = true; }
                });
            });

            it('should not change the slider value', function () {
                assert(slider.setValue(5)).equals(0);
                assert(slider.model.value).equals(0);
            });

            it('should not run change', function () {
                slider.setValue(5);
                assert(changeRun).isFalse();
            });
        }); // when the drag callback returns false

        describe('when the change callback returns false', function () {
            before(function () {
                slider = new $.Quinn(wrapper, {
                    change: function () { return false }
                });
            });

            it('should not change the slider value', function () {
                assert(slider.setValue(5)).equals(0);
                assert(slider.model.value).equals(0);
            });
        }); // when the change callback returns false

        describe('when the value is unchanged', function () {
            var dragRun, changeRun;

            before(function () {
                slider = new $.Quinn(wrapper, {
                    drag:   function () { dragRun   = true; },
                    change: function () { changeRun = true; }
                });

                dragRun   = false;
                changeRun = false;

                slider.setValue(0);
            });

            it('should not run drag', function () {
                assert(dragRun).isFalse();
            });

            it('should not run change', function () {
                assert(changeRun).isFalse();
            });
        }); // when the value is unchanged

        describe('when the value is unchanged during a drag operation', function () {
            var dragRun, changeRun, abortRun;

            before(function () {
                slider = new $.Quinn(wrapper, {
                    drag:   function () { dragRun   = true; },
                    change: function () { changeRun = true; },
                    abort:  function () { abortRun  = true; }
                });

                dragRun   = false;
                changeRun = false;

                slider.start();
                slider.setTentativeValue(50);
                slider.setTentativeValue(0);
                slider.resolve();
            });

            it('should drag', function () {
                assert(dragRun).isTrue();
            });

            it('should not run change', function () {
                assert(changeRun).isFalse();
            });

            it('should run abort', function () {
                assert(abortRun).isTrue();
            });
        }); // when the value is unchanged

        describe('when a drag callback returns false during a drag operation', function () {
            var dragRunCount, lastDragValue;

            before(function () {
                slider = new $.Quinn(wrapper, {
                    drag: function (newValue) {
                        lastDragValue = newValue;
                        dragRunCount++;

                        if (newValue === 50) {
                            return false;
                        }
                    }
                });

                dragRunCount  = 0;
                lastDragValue = null;

                slider.start();
                slider.setTentativeValue(50);
                slider.resolve();
            });

            it('should run the drag callback twice', function () {
                assert(dragRunCount).equals(2);
            });

            it('should run the drag callback with the previous good value', function () {
                assert(lastDragValue).equals(0);
            });

            it('should resolve with the previous good value', function () {
                assert(slider.model.value).equals(0);
            });
        });

        describe('when using the only option', function () {
            before(function () {
                slider = new $.Quinn(wrapper, { value: 40, only: [10, 20, 50] });
            });

            it('should do nothing when given no argument', function () {
                assert(slider.setValue()).equals(50);
                assert(slider.model.value).equals(50);
            });

            it('should set the given value', function () {
                assert(slider.setValue(20)).equals(20);
                assert(slider.model.value).equals(20);

                assert(slider.setValue(10)).equals(10);
                assert(slider.model.value).equals(10);
            });

            it('should set the nearest value when not exact', function () {
                assert(slider.setValue(40)).equals(50);
                assert(slider.model.value).equals(50);
            });
        }); // when using the only option

        describe('when using a range-based slider', function () {
            before(function () {
                slider = new $.Quinn(wrapper, { value: [25, 75] });
            });

            it('should set the new values', function () {
                slider.setValue([10, 90]);
                assert(_.isEqual([10, 90], slider.model.value)).isTrue();
            });

            it('should not permit an integer value', function () {
                assert(_.isEqual(slider.setValue(10), [25, 75])).isTrue();
                assert(_.isEqual([25, 75], slider.model.value)).isTrue();
            });
        });
    });
});
