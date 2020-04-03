/**
 * jQuery :  �����������
 * @author   XiaoDong <cssrain@gmail.com>
 *			 http://www.cssrain.cn
 * @example  $("#test").ProvinceCity();
 * @params   ����
 */
$.fn.ProvinceCity = function(shen,shi){
	var _self = this;
	//����3��Ĭ��ֵ
	_self.data("province",["��ѡ��", ""]);
	_self.data("city1",["��ѡ��",""]);
	_self.data("city2",["��ѡ��",""]);
	//����3���յ�������
	_self.append("<select name=\"u_province\" class=\"z_inputbox\" style=\"width:80px;\"></select>");
	_self.append("<select name=\"u_city\" class=\"z_inputbox\" style=\"width:100px;\"></select>");
	_self.append("<select name=\"u_citym\" class=\"z_inputbox\" style=\"width:120px;\"></select>");
	//�ֱ��ȡ3��������
	var $sel1 = _self.find("select").eq(0);
	var $sel2 = _self.find("select").eq(1);
	var $sel3 = _self.find("select").eq(2);
	//Ĭ��ʡ������
	if(_self.data("province")){
		$sel1.append("<option value='"+_self.data("province")[1]+"'>"+_self.data("province")[0]+"</option>");
	}
	$.each( GP , function(index,data){
		if(data.substr(0,data.length)==shen.substr(0,data.length))
		$sel1.append("<option value='"+data+"' selected>"+data+"</option>");
		else
		$sel1.append("<option value='"+data+"'>"+data+"</option>");
	});
	//Ĭ�ϵ�1����������
	if(_self.data("city1")){
		$sel2.append("<option value='"+_self.data("city1")[1]+"'>"+_self.data("city1")[0]+"</option>");
	}
	//Ĭ�ϵ�2����������
	if(_self.data("city2")){
		$sel3.append("<option value='"+_self.data("city2")[1]+"'>"+_self.data("city2")[0]+"</option>");
	}
	//ʡ������ ����
	var index1 = "" ;
	$sel1.change(function(){
		//�������2��������
		$sel2[0].options.length=0;
		$sel3[0].options.length=0;
		index1 = this.selectedIndex;
		if(index1==0){	//��ѡ���Ϊ ����ѡ�� ʱ
			if(_self.data("city1")){
				$sel2.append("<option value='"+_self.data("city1")[1]+"'>"+_self.data("city1")[0]+"</option>");
			}
			if(_self.data("city2")){
				$sel3.append("<option value='"+_self.data("city2")[1]+"'>"+_self.data("city2")[0]+"</option>");
			}
		}else{
			$.each( GT[index1-1] , function(index,data){
				if(data.substr(0,data.length)==shi.substr(0,data.length))
				$sel2.append("<option value='"+data+"' selected>"+data+"</option>");
				else
				$sel2.append("<option value='"+data+"'>"+data+"</option>");
			});
			$.each( GC[index1-1][$sel2.get(0).selectedIndex] , function(index,data){
				$sel3.append("<option value='"+data+"'>"+data+"</option>");
			})
		}
	}).change();
	//1���������� ����
	var index2 = "" ;
	$sel2.change(function(){
		$sel3[0].options.length=0;
		index2 = this.selectedIndex;
		$.each( GC[index1-1][index2] , function(index,data){
			$sel3.append("<option value='"+data+"'>"+data+"</option>");
		})
	});
	return _self;
};