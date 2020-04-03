/**
 * �������� ��Ʒչʾҳ��
 */
var webHosting2016 = {
    createHoverColumn: function(currentTable, index, target) {

        // ================ ��ʱ���㷽ʽ
        var leftPos = 10;
        var countIndex = 0;
        currentTable.find('thead tr th').each(function() {
            leftPos += this.clientWidth + 1;
            if (++countIndex >= index) {
                return false;
            }
        });
        // ==================

        // ��ȡһ�е�ֵ
        var tableDomArr = [];
        var size = currentTable.find('tr').length - 1;
        var colWidth = 0;
        currentTable.find('tr').each(function(i) {
            var allTd = $(this).find('td');
            if (allTd.length == 0) {
                allTd = $(this).find('th');
            }
            // ��һ�β�ѯ���Ŀ϶��Ǳ�ͷ
            if (!colWidth) {
                colWidth = allTd[index].clientWidth;
            }

            var targetTd = allTd[index];
            if (!targetTd) {
                targetTd = allTd[1];
            }

            if ((+targetTd.colSpan) > 1) {
                targetTd = targetTd.cloneNode(true);
                targetTd.setAttribute('colspan', '1');
            }

            if (size == i) {
                tableDomArr.push('<tr class="last-row">' + targetTd.outerHTML + '</tr>');
            } else {
                tableDomArr.push('<tr>' + targetTd.outerHTML + '</tr>');
            }

        });
        // ���±��
        currentTable.siblings('table').html(tableDomArr.join('')).css({
            left: leftPos + 'px',
            width: (colWidth + 1 + 2) + 'px'
        }).removeClass('hide');

    },

    init: function() {
        var self = this;
        WJF.uiTool.initTab("J_webhostingTabContainer", {
            onTabChange: function(tabId, currentLiDom, currentContentID, prevContentId, prevActiveTabLink, currentActiveTabLink) {
                if (prevActiveTabLink) {
                    prevActiveTabLink.parent('li').removeClass('active');
                }
                currentActiveTabLink.parent('li').addClass('active');
            }
        });

        var tableCurrIndexMapping = {};

        $('.webhosting-info .webhosting-table').on('mouseover', function(event) {
            var target = $(event.target);
            if (event.target.tagName != 'TH' && event.target.tagName != 'TD') {
                if (!target.closest('td').length) {
                    target = target.closest('th');
                } else {
                    target = target.closest('td');
                }
            }
            if (target.hasClass('left')) {
                return;
            }
            var tableIndex = this.getAttribute('data-tableindex');
            // ��¼��ǰ���ѡ���������
            var currentTargetIndex = target.index();
            // ʹ��table dom������Ϊkey ���ܴ������� �ʶ��޸�Ϊtable ID
            if (tableCurrIndexMapping[tableIndex] == currentTargetIndex) {
                return;
            }
            tableCurrIndexMapping[tableIndex] = currentTargetIndex;
            self.createHoverColumn($(this), currentTargetIndex, target);
        });
    }
};
webHosting2016.init();
