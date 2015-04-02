/**
 * Bounds prototype
 * @param {float} x1 Left
 * @param {float} y1 Top
 * @param {float} x2 Right
 * @param {float} y2 Bottom
 */
var Bounds = function (x1, y1, x2, y2) {

	this.x1 = x1;
	this.y1 = y1;
	this.x2 = x2;
	this.y2 = y2;

	this.toArray = function () {
		return [x1, y1, x2, y2];
	}

}
