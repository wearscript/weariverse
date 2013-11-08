// requires three.js

var RotationVectorUtil = {

    DBG: false,

    vec3ToString: function(vec3) {
        return "" + vec3.x + ", " + vec3.y + ", " + vec3.z;
    },

    quatToString: function(quat) {
        return "" + quat.w + ", " + quat.x + ", " + quat.y + ", " + quat.z;
    },

    quatFromVector3: function(vec3) {
        var w = Math.sqrt(1 - vec3.lengthSq());
        return new THREE.Quaternion(vec3.x, vec3.y, vec3.z, w);
    },

    toDegrees: function(rad) {
        return rad * 180 / Math.PI;
    },

    toRadians: function(deg) {
        return deg * Math.PI / 180;
    },

    // phi is left/right = azimuthal = yaw
    phiFromQuat: function(quat) {
        if (this.DBG) {console.log("phiFromQuat " + this.quatToString(quat))}
            var z = new THREE.Vector3(0, 0, 1);
        var zIm = new THREE.Vector3(0, 0, 1);
        zIm.applyQuaternion(quat);
        var zImProjXZ = new THREE.Vector3(zIm.x, 0, zIm.z);
        if (zImProjXZ.length() == 0) {
            return 0;
        } else {
            var phi = z.angleTo(zImProjXZ);
            phi *= THREE.Math.sign(zIm.x);
            return phi;
      }
    },

    // theta is up/down = altitude = pitch
    thetaFromQuat: function(quat) {
        if (this.DBG) {console.log("thetaFromQuat " + this.quatToString(quat))}
        var z = new THREE.Vector3(0, 0, 1);
        var zIm = new THREE.Vector3(0, 0, 1);
        zIm.applyQuaternion(quat);
        var zImProjYZ = new THREE.Vector3(0, zIm.y, zIm.z);
        if (zImProjYZ.length() == 0) {
            return 0;
        } else {
            var theta = z.angleTo(zImProjYZ);
            theta *= THREE.Math.sign(zIm.y);
            return theta;
        }
    },

    zAngleToXZplane: function(quat) {
        var zIm = new THREE.Vector3(0, 0, 1);
        zIm.applyQuaternion(quat);
        var zImProjXZ = new THREE.Vector3(zIm.x, 0, zIm.z);
        return zIm.angleTo(zImProjXZ);
    },

      // psi is viewer rotation = ? = roll
    psiFromQuat: function(quat) {
        if (this.DBG) {console.log("psiFromQuat " + this.quatToString(quat))}
        // apply rotation that moves z axis back by composing an x rotation and a y rotation
        var yAxisIm = new THREE.Vector3(0, 1, 0);
        yAxisIm.applyQuaternion(this.zToZeroQuatNew(quat));
        var psi = yAxisIm.angleTo(new THREE.Vector3(0, 1, 0));
        psi *= THREE.Math.sign(yAxisIm.x); // source of error?
        return psi;
    },

      // psi is viewer rotation = ? = roll
    psiFromQuatX: function(quat) {
        if (this.DBG) {console.log("psiFromQuat " + this.quatToString(quat))}
        // apply rotation that moves z axis back by composing an x rotation and a y rotation
        var xAxisIm = new THREE.Vector3(1, 0, 0);
        xAxisIm.applyQuaternion(this.zToZeroQuatNew(quat));
        var psi = xAxisIm.angleTo(new THREE.Vector3(1, 0, 0));
        psi *= THREE.Math.sign(-xAxisIm.y); // source of error?
        return psi;
    },

    zToZeroQuat: function(quat) {
        var phi = this.phiFromQuat(quat);
        var xRotationAngle = this.zAngleToXZplane(quat);
        var yAxisRotation = new THREE.Quaternion().setFromAxisAngle(new THREE.Vector3(0,1,0), -phi); // what about the sign?
        var xAxisRotation = new THREE.Quaternion().setFromAxisAngle(new THREE.Vector3(1,0,0), xRotationAngle); // what about the sign?
        zToZero = new THREE.Quaternion().copy(xAxisRotation).multiply(yAxisRotation).multiply(quat);
        return zToZero;
        //zIm.applyQuaternion(quat).applyQuaternion(yAxisRotation).applyQuaternion(xAxisRotation); // this should leave us at the z axis
    },

    zToZeroQuatNew: function(quat) {
        var zToYZQuat = this.zToYZPlane(quat);
        var zToZeroQuat = this.zYZtoZAxis(zToYZQuat);
        return zToZeroQuat;
    },

    zToYZPlane: function(quat) {
        var phi = this.phiFromQuat(quat);
        // console.log("zToYZPlane: Phi from quat " + phi);
        var yAxisRotation = new THREE.Quaternion().setFromAxisAngle(new THREE.Vector3(0, 1, 0), -phi);
        return new THREE.Quaternion().copy(yAxisRotation).multiply(quat);
    },

    // make sure to feed in the quat after multiplying by zToYZPlane
    zYZtoZAxis: function(quat) {
        var theta = this.thetaFromQuat(quat);
        var xAxisRotation = new THREE.Quaternion().setFromAxisAngle(new THREE.Vector3(1, 0, 0), theta);
        return new THREE.Quaternion().copy(xAxisRotation).multiply(quat);
    },

    quatToPhiThetaPsi: function(quat) {
        return {
          phi: this.toDegrees(this.phiFromQuat(quat)), 
          theta: this.toDegrees(this.thetaFromQuat(quat)),
          psi: this.toDegrees(this.psiFromQuatX(quat))
        };
    }

}
