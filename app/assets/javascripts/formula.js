String.prototype.toFormulaDecimal = function () {
    var split = this.split('.');
    return split[0].replace(/[^\d.]*/gi, '').replace(/\B(?=(\d{3})+(?!\d))/g, ",") + (typeof split[1] !== 'undefined' ? '.' + split[1].replace(/[^\d.]*/gi, '') : '');
};

String.prototype.toFormulaString = function (shift) {
    var keyCode = parseInt(this);
    if (keyCode === 106) {
        return 'x';
    } else if (((keyCode === 187 || keyCode === 61) && shift === true) || keyCode === 107) {
        return '+';
    } else if (keyCode === 189 || keyCode === 173 || keyCode === 109) {
        return '-';
    } else if (keyCode === 190 || keyCode === 110) {
        return '.';
    } else if (keyCode === 191 || keyCode === 111) {
        return '/';
    } else {
        return String.fromCharCode(keyCode);
    }
};

(function ($) {
    var _PLUGIN_VERSION_ = '2.0.12';

    $.fn.formula = function (opt) {
        var _opt = {
            id: 'formula',
            cursorAnimTime: 160,
            cursorDelayTime: 500,
            strings: {
                formula: 'Formula',
                validationError: 'Validation Error',
                validationPassed: 'Passed'
            },
            import: {
                item: null,
            },
            export: {
                filter: function (data) {
                    var filterData = data;
                    return filterData;
                },
                item: function (e) {
                    return e.data('value') !== 'undefined' && e.data('value') !== null ? e.data('value') : e.text();
                }
            }
        };

        var _args = arguments;
        $.extend(_opt, opt);

        return this.each(function () {
            var $this = $(this);

            $this.data('formula', this);

            this.init = function () {
                var context = this;

                var drag = false, move = false, offset = null;
                context.container = $(context).addClass(context.opt.id + '-container');
                context.container.wrap('<div class="' + context.opt.id + '-wrapper"></div>');

                context.alert = $('<div class="' + context.opt.id + '-alert">' + _opt.strings.formula + '</div>');
                context.alert.insertBefore(context.container);

                context.text = $('<textarea id="' + context.opt.id + '-text" name="' + context.opt.id + '-text" class="' + context.opt.id + '-text"></textarea>');
                context.text.insertAfter(context.container).focus();
                context.text.bind('blur', function () {
                    if (context.cursor !== null) {
                        context.cursor.remove();
                        context.destroyDrag();
                    }
                });

                context.text.unbind('dblclick.' + context.opt.id + 'Handler').bind('dblclick.' + context.opt.id + 'Handler', function (event) {
                    context.selectAll();
                });

                context.text.unbind('mousedown.' + context.opt.id + 'Handler').bind('mousedown.' + context.opt.id + 'Handler', function (event) {
                    drag = true;

                    offset = {
                        x: event.offsetX,
                        y: event.offsetY
                    };
                });

                context.text.unbind('mouseup.' + context.opt.id + 'Handler').bind('mouseup.' + context.opt.id + 'Handler', function (event) {
                    drag = false;
                    if (move === true) {
                        move = false;
                    } else {
                        context.click({
                            x: event.offsetX,
                            y: event.offsetY
                        });
                    }
                });

                var startIndex;
                context.text.unbind('mousemove.' + context.opt.id + 'Handler').bind('mousemove.' + context.opt.id + 'Handler', function (event) {
                    if (drag === false) {
                        return true;
                    }

                    if (Math.abs(offset.x - event.offsetX) <= 5 && Math.abs(offset.y - event.offsetY) <= 5) {
                        return true;
                    }

                    if (context.container.hasClass('formula-active')) {
                        context.click({
                            x: event.offsetX,
                            y: event.offsetY
                        });
                    }

                    move = true;
                    if (context.container.find('.' + context.opt.id + '-drag').length > 0) {
                        var endIndex = 0;
                        context.destroyDrag();
                        context.click({
                            x: event.offsetX,
                            y: event.offsetY
                        });
                        endIndex = context.cursor.index();

                        $drag = $('<div class="' + context.opt.id + '-drag"></div>');
                        var start = 0, end = 0;
                        if (startIndex > endIndex) {
                            end = startIndex;
                            start = endIndex;
                            $drag.insertBefore(context.cursor);
                        } else {
                            start = startIndex;
                            end = endIndex;
                            $drag.insertAfter(context.cursor);
                        }

                        if (start === end) {
                            return true;
                        }

                        context.container.children(':not(".' + context.opt.id + '-cursor")').filter(':gt("' + start + '")').filter(':lt("' + (end - start) + '")')
                        .add(context.container.children(':not(".' + context.opt.id + '-cursor")').eq(start)).each(function () {
                            var $this = $(this);
                            $this.appendTo($drag);
                        });

                        if (startIndex > endIndex) {
                            $drag.insertAfter(context.cursor);
                        } else {
                            $drag.insertBefore(context.cursor);
                        }
                    } else {
                        context.destroyDrag();
                        context.click({
                            x: event.offsetX,
                            y: event.offsetY
                        });
                        startIndex = context.cursor.index();

                        $drag = $('<div class="' + context.opt.id + '-drag"></div>');
                        $drag.insertAfter(context.cursor);
                    }
                });

                context.text.unbind('keydown.' + context.opt.id + 'Handler').bind('keydown.' + context.opt.id + 'Handler', function (event) {
                    event.preventDefault();
                    var $drag, $prev, $next, $item, $dragItem, text, parentPadding;

                    if (context.cursor !== null && context.cursor.length > 0) {
                        var keyCode = event.which;
                        if (keyCode === 116 || (keyCode === 82 && event.ctrlKey)) {
                            location.reload();
                        } else if (keyCode === 65 && event.ctrlKey) {
                            context.selectAll();
                        } else if (keyCode >= 96 && keyCode <= 105) {
                            keyCode -= 48;
                        } else if (keyCode === 8) {
                            $drag = context.container.find('.' + context.opt.id + '-drag');
                            if ($drag.length > 0) {
                                context.cursor.insertBefore($drag);
                                $drag.remove();
                            } else if (context.cursor.length > 0 && context.cursor.prev().length > 0) {
                                $prev = context.cursor.prev();
                                if ($prev.hasClass(context.opt.id + '-unit') && $prev.text().length > 1) {
                                    text = $prev.text();
                                    context.setDecimal($prev, text.substring(0, text.length - 1).toFormulaDecimal());
                                } else {
                                    $prev.remove();
                                }
                            }
                            context.syntaxCheck();
                            $this.triggerHandler('formula.input', context.getFormula());
                            return false;
                        } else if (keyCode === 46) {
                            $drag = context.container.find('.' + context.opt.id + '-drag');
                            if ($drag.length > 0) {
                                context.cursor.insertAfter($drag);
                                $drag.remove();
                            } else {
                                if (context.cursor.length > 0 && context.cursor.next().length > 0) {
                                    $next = context.cursor.next();
                                    if ($next.hasClass(context.opt.id + '-unit') && $next.text().length > 1) {
                                        text = $next.text();
                                        context.setDecimal($next, text.substring(1, text.length).toFormulaDecimal());
                                    } else {
                                        $next.remove();
                                    }
                                }
                            }
                            context.syntaxCheck();
                            $this.triggerHandler('formula.input', context.getFormula());
                            return false;
                        } else if (keyCode >= 37 && keyCode <= 40) {
                            if (keyCode === 37) {
                                if (context.cursor.length > 0 && context.cursor.prev().length > 0) {
                                    if (event.shiftKey) {
                                        $drag = context.container.find('.' + context.opt.id + '-drag');
                                        if ($drag.length < 1) {
                                            $drag = $('<div class="' + context.opt.id + '-drag"></div>');
                                            $drag.insertAfter(context.cursor);
                                        } else {
                                            if ($drag.data('active') === false) {
                                                context.destroyDrag();
                                                $drag = $('<div class="' + context.opt.id + '-drag"></div>');
                                                $drag.insertAfter(context.cursor);
                                            }
                                        }
                                        $drag.data('active', true);

                                        $prev = context.cursor.prev();
                                        if ($prev.hasClass(context.opt.id + '-drag')) {
                                            $dragItem = $drag.children('*');
                                            if ($dragItem.length < 1) {
                                                $drag.remove();
                                            } else {
                                                $dragItem.last().insertAfter($drag);
                                                context.cursor.insertAfter($drag);
                                            }
                                        } else {
                                            context.cursor.prev().prependTo($drag);
                                        }
                                    } else {
                                        context.destroyDrag();
                                        context.cursor.insertBefore(context.cursor.prev());
                                    }
                                } else {
                                    context.destroyDrag();
                                }
                            } else if (keyCode === 38) {
                                if (context.cursor.prev().length > 0 || context.cursor.next().length > 0) {
                                    parentPadding = {
                                        x: parseFloat(context.container.css('padding-left').replace(/[^\d.]/gi, '')),
                                        y: parseFloat(context.container.css('padding-top').replace(/[^\d.]/gi, ''))
                                    };

                                    $item = context.cursor.prev();
                                    if ($item.length < 0) {
                                        $item = context.cursor.next();
                                    }
                                    context.click({
                                        x: context.cursor.position().left + $item.outerWidth(),
                                        y: context.cursor.position().top - $item.outerHeight() / 2
                                    });
                                } else {

                                }
                            } else if (keyCode === 39) {
                                if (context.cursor.length > 0 && context.cursor.next().length > 0) {
                                    if (event.shiftKey) {
                                        $drag = context.container.find('.' + context.opt.id + '-drag');
                                        if ($drag.length < 1) {
                                            $drag = $('<div class="' + context.opt.id + '-drag"></div>');
                                            $drag.insertBefore(context.cursor);
                                        } else {
                                            if ($drag.data('active') === false) {
                                                context.destroyDrag();
                                                $drag = $('<div class="' + context.opt.id + '-drag"></div>');
                                                $drag.insertBefore(context.cursor);
                                            }
                                        }
                                        $drag.data('active', true);

                                        $next = context.cursor.next();
                                        if ($next.hasClass(context.opt.id + '-drag')) {
                                            $dragItem = $drag.children('*');
                                            if ($dragItem.length < 1) {
                                                $drag.remove();
                                            } else {
                                                $dragItem.first().insertBefore($drag);
                                                context.cursor.insertBefore($drag);
                                            }
                                        } else {
                                            context.cursor.next().appendTo($drag);
                                        }
                                    } else {
                                        context.destroyDrag();
                                        context.cursor.insertAfter(context.cursor.next());
                                    }
                                } else {
                                    context.destroyDrag();
                                }
                            } else if (keyCode === 40) {
                                if (context.cursor.prev().length > 0 || context.cursor.next().length > 0) {
                                    parentPadding = {
                                        x: parseFloat(context.container.css('padding-left').replace(/[^\d.]/gi, '')),
                                        y: parseFloat(context.container.css('padding-top').replace(/[^\d.]/gi, ''))
                                    };

                                    $item = context.cursor.prev();
                                    if ($item.length < 0) {
                                        $item = context.cursor.next();
                                    }
                                    context.click({
                                        x: context.cursor.position().left + $item.outerWidth(),
                                        y: context.cursor.position().top + $item.outerHeight() * 1.5
                                    });
                                } else {

                                }
                            }
                            return false;
                        } else if (keyCode === 35 || keyCode === 36) {
                            if (keyCode === 35) {
                                if (context.cursor.length > 0 && context.container.children(':last').length > 0) {
                                    if (event.shiftKey) {
                                        $drag = context.container.find('.' + context.opt.id + '-drag');
                                        if ($drag.length < 1) {
                                            $drag = $('<div class="' + context.opt.id + '-drag"></div>');
                                            $drag.insertBefore(context.cursor);
                                        } else {
                                            if ($drag.data('active') === false) {
                                                context.destroyDrag();
                                                $drag = $('<div class="' + context.opt.id + '-drag"></div>');
                                                $drag.insertBefore(context.cursor);
                                            }
                                        }
                                        $drag.data('active', true);
                                        context.cursor.nextAll().appendTo($drag);
                                    } else {
                                        context.destroyDrag();
                                        context.cursor.insertAfter(context.container.children(':last'));
                                    }
                                }
                            } else if (keyCode === 36) {
                                if (context.cursor.length > 0 && context.container.children(':first').length > 0) {
                                    if (event.shiftKey) {
                                        $drag = context.container.find('.' + context.opt.id + '-drag');
                                        if ($drag.length < 1) {
                                            $drag = $('<div class="' + context.opt.id + '-drag"></div>');
                                            $drag.insertAfter(context.cursor);
                                        } else {
                                            if ($drag.data('active') === false) {
                                                context.destroyDrag();
                                                $drag = $('<div class="' + context.opt.id + '-drag"></div>');
                                                $drag.insertAfter(context.cursor);
                                            }
                                        }
                                        $drag.data('active', true);
                                        context.cursor.prevAll().each(function () {
                                            var $this = $(this);
                                            $this.prependTo($drag);
                                        });
                                    } else {
                                        context.destroyDrag();
                                        context.cursor.insertBefore(context.container.children(':first'));
                                    }
                                }
                            } else {
                                return false;
                            }
                        } else if ((keyCode >= 48 && keyCode <= 57) === false &&
                                  (keyCode !== 88 && keyCode !== 187 && keyCode !== 189 && keyCode !== 190 && keyCode !== 191) === true) {
                            return false;
                        }

                        context.keydown(keyCode.toString().toFormulaString(event.shiftKey), event.shiftKey);
                        context.syntaxCheck();
                    }
                });
            };

            this.syntaxCheck = function (callback) {
                var context = this;

                var formula = context.getFormula().data;

                if (typeof formula !== 'undefined') {
                    var result = new FormulaParser(formula);
                    if (result.status === true) {
                        context.alert.text(context.opt.strings.validationPassed).addClass(context.opt.id + '-alert-good').removeClass(context.opt.id + '-alert-error');
                        if (typeof callback === 'function') {
                            callback(true);
                        }
                        return true;
                    }
                    else {
                        context.alert.text(context.opt.strings.validationError).removeClass(context.opt.id + '-alert-good').addClass(context.opt.id + '-alert-error');
                        if (typeof callback === 'function') {
                            callback(false);
                        }
                        return false;
                    }
                }
            };

            this.destroyDrag = function () {
                var context = this;

                var $drag = context.container.find('.' + context.opt.id + '-drag');
                $drag.children('*').each(function () {
                    var $this = $(this);
                    $this.insertBefore($drag);
                });
                $drag.remove();
                $this.triggerHandler('formula.input', context.getFormula());
            };

            this.selectAll = function () {
                var context = this;

                context.destroyDrag();
                $drag = $('<div class="' + context.opt.id + '-drag"></div>');
                $drag.prependTo(context.container);
                context.container.children(':not(".' + context.opt.id + '-cursor")').each(function () {
                    var $this = $(this);
                    $this.appendTo($drag);
                });
            };

            this.click = function (position) {
                var context = this;

                context.container.find('.' + context.opt.id + '-cursor').remove();

                var $cursor = $('<div class="' + context.opt.id + '-cursor"></div>');
                var check = null, idx = null;
                position = position || { x: 0, y: 0 };
                $cursor.appendTo(context.container);
                context.cursor = $cursor;

                var parentPos = {
                    x: context.container.offset().left,
                    y: context.container.offset().top
                };

                var parentPadding = {
                    x: parseFloat(context.container.css('padding-left').replace(/[^\d.]/gi, '')),
                    y: parseFloat(context.container.css('padding-top').replace(/[^\d.]/gi, ''))
                };

                var checkArea = [];

                context.container.children('*:not(".' + context.opt.id + '-cursor")').each(function () {
                    var $this = $(this);
                    checkArea.push({
                        x: $this.offset().left - parentPos.x + parentPadding.x,
                        y: $this.offset().top - parentPos.y,
                        e: $this
                    });
                });


                var $pointer = null;
                var maxY = 0, maxDiff = 10000;
                for (idx in checkArea) {
                    check = checkArea[idx];
                    if (check.y <= position.y) {
                        if (check.y >= maxY * 0.5 && check.x <= position.x) {
                            if (check.y >= maxY) {
                                maxY = check.y;
                            }
                            if (position.x - check.x <= maxDiff) {
                                maxDiff = position.x - check.x;
                                $pointer = check.e;
                            }
                        }
                    }
                }

                if ($pointer === null) {
                    maxY = 0;
                    maxDiff = 10000;
                    for (idx in checkArea) {
                        check = checkArea[idx];
                        if (check.y >= maxY * 0.5 && check.x <= position.x) {
                            if (check.y >= maxY) {
                                maxY = check.y;
                            }
                            if (position.x - check.x < maxDiff) {
                                maxDiff = position.x - check.x;
                                $pointer = check.e;
                            }
                        }
                    }
                }

                if (checkArea.length > 0 && $pointer !== null && maxY + checkArea[0].e.outerHeight() >= position.y) {
                    context.cursor.insertAfter($pointer);
                } else {
                    if (checkArea.length > 0 && position.x > checkArea[0].x) {
                        context.cursor.appendTo(context.container);
                    } else {
                        context.cursor.prependTo(context.container);
                    }
                }

                var loop = function () {
                    setTimeout(function () {
                        if ($cursor.hasClass('inactive')) {
                            $cursor.removeClass('inactive');
                            $cursor.stop().animate({ opacity: 1 }, context.opt.cursorAnimTime);
                        } else {
                            $cursor.addClass('inactive');
                            $cursor.stop().animate({ opacity: 0 }, context.opt.cursorAnimTime);
                        }

                        if ($cursor.length > 0) {
                            loop();
                        }
                    }, context.opt.cursorDelayTime);
                };
                loop();

                context.destroyDrag();
            };

            this.keydown = function (key, shift) {
                var context = this;

                var convert = {
                    0: ')',
                    1: '!',
                    2: '@',
                    3: '#',
                    4: '$',
                    5: '%',
                    6: '^',
                    7: '&',
                    8: 'x',
                    9: '('
                };

                if (shift && (key >= 0 && key <= 9)) {
                    key = convert[key];
                }
                key = $.trim(key);

                context.insertChar.call(context, key);
            };

            this.insert = function (item, position) {
                var context = this;

                if (context.cursor === null || context.cursor.length < 1 || typeof position === 'object') {
                    context.click(position);
                }

                if (typeof item === 'string') {
                    item = $(item);
                }

                item.addClass(context.opt.id + '-item');
                item.insertBefore(context.cursor);

                context.text.focus();
                context.syntaxCheck();

                $this.triggerHandler('formula.input', context.getFormula());
            };

            this.insertChar = function (key) {
                var context = this;

                if ((key >= 0 && key <= 9) || $.inArray(key.toLowerCase(), context.permitedKey) != -1) {
                    if ((key >= 0 && key <= 9) || key === '.') {
                        var $unit = $('<div class="' + context.opt.id + '-item ' + context.opt.id + '-unit">' + key + '</div>');
                        var $item = null;
                        var decimal = '', merge = false;

                        $drag = context.container.find('.' + context.opt.id + '-drag');

                        if ($drag.length > 0) {
                            context.cursor.insertBefore($drag);
                            $drag.remove();
                        }

                        if (context.cursor !== null && context.cursor.length > 0) {
                            context.cursor.before($unit);
                        } else {
                            context.container.append($unit);
                        }

                        var $prev = $unit.prev();
                        var $next = $unit.next();

                        if ($prev.length > 0 && $prev.hasClass(context.opt.id + '-cursor')) {
                            $prev = $prev.prev();
                        }

                        if ($next.length > 0 && $next.hasClass(context.opt.id + '-cursor')) {
                            $next = $next.next();
                        }

                        if ($prev.length > 0 && $prev.hasClass(context.opt.id + '-unit')) {
                            merge = true;
                            $item = $prev;
                            $item.append($unit[0].innerHTML);
                        } else if ($next.length > 0 && $next.hasClass(context.opt.id + '-unit')) {
                            merge = true;
                            $item = $next;
                            $item.prepend($unit[0].innerHTML);
                        }

                        if (merge === true) {
                            decimal = $item.text().toFormulaDecimal();
                            context.setDecimal($item, decimal);
                            $unit.remove();
                        }
                    } else if (key !== '') {
                        var $operator = $('<div class="' + context.opt.id + '-item ' + context.opt.id + '-operator">' + key.toLowerCase() + '</div>');
                        if (context.cursor !== null && context.cursor.length > 0) {
                            context.cursor.before($operator);
                        } else {
                            context.container.append($operator);
                        }
                        if (key === '(' || key === ')') {
                            $operator.addClass(context.opt.id + '-bracket');
                        }
                    }

                    $this.triggerHandler('formula.input', context.getFormula());
                }
            };

            this.insertFormula = function (data) {
                var context = this;
                var idx = 0;

                if (typeof data === 'string') {
                    var data_split = data.split('');
                    for (idx in data_split) {
                        context.insertChar.call(context, data_split[idx]);
                    }
                } else {
                    for (idx in data) {
                        var item = data[idx];
                        if (typeof item !== 'object') {
                            var data_splited = item.toString().split('');
                            for (var key in data_splited) {
                                context.insertChar.call(context, data_splited[key]);
                            }
                        } else {
                            if (typeof context.opt.import.item === 'function') {
                                var $e = context.opt.import.item.call(context, item);
                                if (typeof $e !== 'undefined' && $e !== null) {
                                    context.insert($e);
                                }
                            }
                        }
                    }
                }
                context.syntaxCheck();

                $this.triggerHandler('formula.input', context.getFormula());
            };

            this.empty = function () {
                var context = this;

                context.container.find(':not(".' + context.opt.id + '-cursor")').remove();
                $this.triggerHandler('formula.input', context.getFormula());

                return context.container;
            };

            this.setDecimal = function (element, decimal) {
                var context = this;

                if (decimal !== '') {
                    element.empty();
                    var split = decimal.split('.');
                    var $prefix = $('<span class="' + context.opt.id + '-prefix ' + context.opt.id + '-decimal-highlight">' + split[0] + '</span>');
                    $prefix.appendTo(element);

                    if (typeof split[1] !== 'undefined') {
                        var $surfix = $('<span class="' + context.opt.id + '-surfix ' + context.opt.id + '-decimal-highlight">.' + split[1] + '</span>');
                        $surfix.appendTo(element);
                    }
                }
            };

            this.setFormula = function (data) {
                var context = this;

                context.empty();
                try {
                    var obj = null;
                    if (typeof data !== 'object') {
                        obj = JSON.parse(data);
                    } else {
                        obj = data;
                    }

                    var decodedData = new FormulaParser(obj);
                    if (decodedData.status === true) {
                        context.insertFormula.call(context, decodedData.data);
                    }
                } catch (e) {
                    console.trace(e.stack);
                }
            };

            this.getFormula = function (callback) {
                var context = this;

                var data = [];
                var filterData = null;
                var result;

                if (typeof context.opt.export.filter === 'function') {
                    context.container.find('.formula-item').each(function () {
                        var $this = $(this);
                        var item = {};
                        item.value = ($this.data('value') ? $this.data('value') : $this.text());

                        if ($this.hasClass(context.opt.id + '-unit')) {
                            item.type = 'unit';
                            item.value = item.value.toFormulaDecimal();
                        } else if ($this.hasClass(context.opt.id + '-custom')) {
                            item.type = 'item';
                            if (typeof context.opt.export !== 'undefined' && typeof context.opt.export.item === 'function') {
                                try {
                                    item.value = context.opt.export.item.call(context, $this);
                                } catch (e) {
                                    item.value = '0';
                                }
                            } else {
                                item.value = '0';
                            }
                        } else if ($this.hasClass(context.opt.id + '-operator')) {
                            item = item.value === 'x' ? '*' : item.value;
                        }
                        data.push(item);
                    });

                    data = data;
                    filterData = new FormulaParser(Object.assign([], data));
                    filterData.data = context.opt.export.filter(filterData.data);

                    result = {
                        data: data,
                        filterData: filterData
                    };
                } else {
                    context.container.find('.formula-item').each(function () {
                        var $this = $(this);
                        var value = ($this.data('value') ? $this.data('value') : $this.text());
                        if ($this.hasClass(context.opt.id + '-unit')) {
                            value = value.toFormulaDecimal();
                        } else if ($this.hasClass(context.opt.id + '-operator') && value === 'x') {
                            value = '*';
                        } else if ($this.hasClass(context.opt.id + '-custom')) {
                            if (typeof context.opt.export !== 'undefined' && typeof context.opt.export.item === 'function') {
                                try {
                                    value = context.opt.export.call(context, $this);
                                } catch (e) {
                                    value = '0';
                                }
                            } else {
                                value = '0';
                            }
                        }
                        data.push(value);
                    });

                    result = {
                        data: data.join(' '),
                        filterData: filterData
                    };
                }

                if (typeof callback === 'function') {
                    callback(result);
                }

                return result;
            };

            if (_args.length < 1 || typeof _args[0] === 'object') {
                this.alert = null;
                this.text = null;
                this.container = null;
                this.cursor = null;
                this.opt = _opt;
                this.permitedKey = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 'x', '*', '/', '.', '+', '-', '%', '^', '(', ')'];
                $.extend(opt, _opt);
                this.init.call(this);
            } else {
                this[opt].apply(this, Array.prototype.slice.call(_args, 1));
            }
        });
    };

    $.fn.formula.getVersion = function () {
        return _PLUGIN_VERSION_;
    };
}(jQuery));
