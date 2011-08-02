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
                assert(slider.value).equals(50);
            });

            it('should add the old value to previousValues', function () {
                assert(slider.previousValues).isSameAs([0]);
            });

            it('should not permit values larger than the selectable range', function () {
                assert(slider.setValue(101)).equals(100);
                assert(slider.value).equals(100);
            });

            it('should not permit values smaller than the selectable range', function () {
                assert(slider.setValue(-1)).equals(0);
                assert(slider.value).equals(0);
            });

            it('should run the onChange callback', function () {
                var onChangeRun = false;

                slider = new $.Quinn(wrapper, {
                    onChange: function () {
                        onChangeRun = true;
                    }
                });

                slider.setValue(50);
                assert(onChangeRun).isTrue();
            });

            it('should run the onCommit callback', function () {
                var onCommitRun = false;

                slider = new $.Quinn(wrapper, {
                    onCommit: function () {
                        onCommitRun = true;
                    }
                });

                slider.setValue(50);
                assert(onCommitRun).isTrue();
            });
        }); // when setting a value

        describe('when the slider is disabled', function () {
            before(function () {
                slider = new $.Quinn(wrapper, { disable: true });
            });

            it('should not change the slider value', function () {
                assert(slider.setValue(50)).equals(false)
                assert(slider.value).equals(0);
            });

            it('should not change previousValues', function () {
                assert(slider.previousValues.length).equals(0);
            });
        }); // when the slider is disabled

        describe('when given no argument', function () {
            before(function () {
                slider = new $.Quinn(wrapper, { value: 50 });
            });

            it('should set the slider to the minimum value', function () {
                assert(slider.setValue()).equals(0);
                assert(slider.value).equals(0);
            });

            it('should add the old value to previousValues', function () {
                slider.setValue();
                assert(slider.previousValues).isSameAs([50]);
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
                    return slider.value;
                });

                assert(rounded).isSameAs(rounds);
            });
        }); // when the value does not match the step

        describe('when the onChange callback returns false', function () {
            var onCommitRun;

            before(function () {
                slider = new $.Quinn(wrapper, {
                    onChange: function () { return false },
                    onCommit: function () { onCommitRun = true; }
                });
            });

            it('should not change the slider value', function () {
                assert(slider.setValue(5)).equals(0);
                assert(slider.value).equals(0);
            });

            it('should not change previousValues', function () {
                assert(slider.previousValues.length).equals(0);
            });

            it('should not run onCommit', function () {
                slider.setValue(5);
                assert(onCommitRun).isFalse();
            });
        }); // when the onChange callback returns false

        describe('when the onCommit callback returns false', function () {
            before(function () {
                slider = new $.Quinn(wrapper, {
                    onCommit: function () { return false }
                });
            });

            it('should not change the slider value', function () {
                assert(slider.setValue(5)).equals(0);
                assert(slider.value).equals(0);
            });

            it('should not change previousValues', function () {
                assert(slider.previousValues.length).equals(0);
            });
        }); // when the onCommit callback returns false

        describe('when the value is unchanged', function () {
            var onChangeRun, onCommitRun;

            before(function () {
                slider = new $.Quinn(wrapper, {
                    onChange: function () { onChangeRun = true },
                    onCommit: function () { onCommitRun = true; }
                });

                slider.setValue(0);
            });

            it('should not change previousValues', function () {
                assert(slider.previousValues.length).equals(0);
            });

            it('should not run onChange', function () {
                assert(onChangeRun).isFalse();
            });

            it('should not run onCommit', function () {
                assert(onCommitRun).isFalse();
            });
        }); // when the value is unchanged

        describe('when using the only option', function () {
            before(function () {
                slider = new $.Quinn(wrapper, { value: 40, only: [10, 20, 50] });
            });

            it('should set the first value when given no argument', function () {
                assert(slider.setValue()).equals(10);
                assert(slider.value).equals(10);
            });

            it('should set the given value', function () {
                assert(slider.setValue(50)).equals(50);
                assert(slider.value).equals(50);
            });

            it('should set the nearest value when not exact', function () {
                assert(slider.setValue(40)).equals(50);
                assert(slider.value).equals(50);
            });
        }); // when using the only option
    });
});
