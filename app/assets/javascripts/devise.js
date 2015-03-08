$("#uploadFormTitle").onchange = function () {
	$('#ma-uploadform-title').html(this.files[0].name);
};
