using UnityEngine;


namespace AmazingAssets.CurvedWorld
{
    public enum BEND_TYPE
    {
        ClassicRunner_X_Positive = 0, ClassicRunner_X_Negative, ClassicRunner_Z_Positive, ClassicRunner_Z_Negative,
        LittlePlanet_X, LittlePlanet_Y, LittlePlanet_Z,
        CylindricalTower_X, CylindricalTower_Z,
        CylindricalRolloff_X, CylindricalRolloff_Z,

        SpiralHorizontal_X_Positive, SpiralHorizontal_X_Negative, SpiralHorizontal_Z_Positive, SpiralHorizontal_Z_Negative,
        SpiralHorizontalDouble_X, SpiralHorizontalDouble_Z,
        SpiralHorizontalRolloff_X, SpiralHorizontalRolloff_Z,

        SpiralVertical_X_Positive, SpiralVertical_X_Negative, SpiralVertical_Z_Positive, SpiralVertical_Z_Negative,
        SpiralVerticalDouble_X, SpiralVerticalDouble_Z,
        SpiralVerticalRolloff_X, SpiralVerticalRolloff_Z,

        TwistedSpiral_X_Positive, TwistedSpiral_X_Negative, TwistedSpiral_Z_Positive, TwistedSpiral_Z_Negative,
    };

    [ExecuteAlways]
    public class CurvedWorldController : MonoBehaviour
    {
        public enum AXIS_TYPE { Transform, Custom, CustomNormalized }

        public BEND_TYPE bendType;
        [Range(1, 32)]
        public int bendID = 1;

        public Transform bendPivotPoint; public Vector3 bendPivotPointPosition;
        public Transform bendRotationCenter; public Vector3 bendRotationCenterPosition; public Vector3 bendRotationAxis; public AXIS_TYPE bendRotationAxisType;
        public Transform bendRotationCenter2; public Vector3 bendRotationCenter2Position;


        public float bendVerticalSize, bendVerticalOffset;
        public float bendHorizontalSize, bendHorizontalOffset;
        public float bendCurvatureSize, bendCurvatureOffset;

        public float bendAngle;
        public float bendAngle2;
        public float bendMinimumRadius;
        public float bendMinimumRadius2;
        public float bendRolloff;

        public bool disableInEditor = false;
        public bool manualUpdate = false;


        BEND_TYPE previousBentType;
        int previousID;

        int materialPropertyID_PivotPoint;
        int materialPropertyID_RotationCenter;
        int materialPropertyID_RotationCenter2;
        int materialPropertyID_RotationAxis;
        int materialPropertyID_BendSize;
        int materialPropertyID_BendOffset;
        int materialPropertyID_BendAngle;
        int materialPropertyID_BendMinimumRadius;
        int materialPropertyID_BendRolloff;


#if UNITY_EDITOR
        public bool isExpanded = true;
#endif




        void OnDisable()
        {
            DisableBend();
        }

        void OnDestroy()
        {
            DisableBend();
        }

        void OnEnable()
        {
            EnableBend();
        }

        void Start()
        {
            GenerateShaderPropertyIDs();
        }

        void Update()
        {
            if (manualUpdate)
                return;

            UpdateShaderdata();
        }

        private void OnDrawGizmos()
        {
            Gizmos.color = Color.yellow;
            switch (bendType)
            {
                case BEND_TYPE.TwistedSpiral_X_Positive:
                case BEND_TYPE.TwistedSpiral_X_Negative:
                case BEND_TYPE.TwistedSpiral_Z_Positive:
                case BEND_TYPE.TwistedSpiral_Z_Negative:
                    {
                        Gizmos.DrawRay(bendPivotPointPosition, bendRotationAxis.normalized * 10);

                    }
                    break;
            }
        }


        void UpdateShaderdata()
        {
            CheckBendChanging();


            if (isActiveAndEnabled == true)
            {
                if (disableInEditor && Application.isEditor && Application.isPlaying == false)
                {
                    UpdateShaderDataDisabled();
                }
                else
                {
                    if (bendPivotPoint != null)
                        bendPivotPointPosition = bendPivotPoint.transform.position;

                    if (bendRotationCenter != null)
                        bendRotationCenterPosition = bendRotationCenter.position;

                    if (bendRotationCenter2 != null)
                        bendRotationCenter2Position = bendRotationCenter2.position;


                    switch (bendType)
                    {
                        case BEND_TYPE.ClassicRunner_X_Positive:
                        case BEND_TYPE.ClassicRunner_X_Negative:
                        case BEND_TYPE.ClassicRunner_Z_Positive:
                        case BEND_TYPE.ClassicRunner_Z_Negative:
                            {
                                Shader.SetGlobalVector(materialPropertyID_PivotPoint, bendPivotPointPosition);
                                Shader.SetGlobalVector(materialPropertyID_BendSize, new Vector2(bendVerticalSize, bendHorizontalSize));
                                Shader.SetGlobalVector(materialPropertyID_BendOffset, new Vector2(bendVerticalOffset, bendHorizontalOffset));

                            }
                            break;

                        case BEND_TYPE.LittlePlanet_X:
                        case BEND_TYPE.LittlePlanet_Y:
                        case BEND_TYPE.LittlePlanet_Z:
                        case BEND_TYPE.CylindricalTower_X:
                        case BEND_TYPE.CylindricalTower_Z:
                        case BEND_TYPE.CylindricalRolloff_X:
                        case BEND_TYPE.CylindricalRolloff_Z:
                            {
                                Shader.SetGlobalVector(materialPropertyID_PivotPoint, bendPivotPointPosition);
                                Shader.SetGlobalFloat(materialPropertyID_BendSize, bendCurvatureSize);
                                Shader.SetGlobalFloat(materialPropertyID_BendOffset, bendCurvatureOffset);

                            }
                            break;

                        case BEND_TYPE.SpiralHorizontal_X_Positive:
                        case BEND_TYPE.SpiralHorizontal_X_Negative:
                        case BEND_TYPE.SpiralHorizontal_Z_Positive:
                        case BEND_TYPE.SpiralHorizontal_Z_Negative:
                        case BEND_TYPE.SpiralVertical_X_Positive:
                        case BEND_TYPE.SpiralVertical_X_Negative:
                        case BEND_TYPE.SpiralVertical_Z_Positive:
                        case BEND_TYPE.SpiralVertical_Z_Negative:
                            {
                                Shader.SetGlobalVector(materialPropertyID_PivotPoint, bendPivotPointPosition);
                                Shader.SetGlobalVector(materialPropertyID_RotationCenter, bendRotationCenterPosition);
                                Shader.SetGlobalFloat(materialPropertyID_BendAngle, bendAngle);
                                Shader.SetGlobalFloat(materialPropertyID_BendMinimumRadius, bendMinimumRadius);

                            }
                            break;

                        case BEND_TYPE.SpiralHorizontalDouble_X:
                        case BEND_TYPE.SpiralHorizontalDouble_Z:
                        case BEND_TYPE.SpiralVerticalDouble_X:
                        case BEND_TYPE.SpiralVerticalDouble_Z:
                            {
                                Shader.SetGlobalVector(materialPropertyID_PivotPoint, bendPivotPointPosition);
                                Shader.SetGlobalVector(materialPropertyID_RotationCenter, bendRotationCenterPosition);
                                Shader.SetGlobalVector(materialPropertyID_RotationCenter2, bendRotationCenter2Position);
                                Shader.SetGlobalVector(materialPropertyID_BendAngle, new Vector2(bendAngle, bendAngle2));
                                Shader.SetGlobalVector(materialPropertyID_BendMinimumRadius, new Vector2(bendMinimumRadius, bendMinimumRadius2));
                            }
                            break;

                        case BEND_TYPE.SpiralHorizontalRolloff_X:
                        case BEND_TYPE.SpiralHorizontalRolloff_Z:
                        case BEND_TYPE.SpiralVerticalRolloff_X:
                        case BEND_TYPE.SpiralVerticalRolloff_Z:
                            {
                                Shader.SetGlobalVector(materialPropertyID_PivotPoint, bendPivotPointPosition);
                                Shader.SetGlobalVector(materialPropertyID_RotationCenter, bendRotationCenterPosition);
                                Shader.SetGlobalFloat(materialPropertyID_BendAngle, bendAngle);
                                Shader.SetGlobalFloat(materialPropertyID_BendMinimumRadius, bendMinimumRadius);
                                Shader.SetGlobalFloat(materialPropertyID_BendRolloff, bendRolloff);
                            }
                            break;

                        case BEND_TYPE.TwistedSpiral_X_Positive:
                        case BEND_TYPE.TwistedSpiral_X_Negative:
                        case BEND_TYPE.TwistedSpiral_Z_Positive:
                        case BEND_TYPE.TwistedSpiral_Z_Negative:
                            {
                                switch (bendRotationAxisType)
                                {
                                    case AXIS_TYPE.Transform:
                                        {
                                            if (bendPivotPoint == null)
                                            {
                                                switch (bendType)
                                                {
                                                    case BEND_TYPE.ClassicRunner_X_Positive: bendRotationAxis = Vector3.left; break;
                                                    case BEND_TYPE.ClassicRunner_X_Negative: bendRotationAxis = Vector3.right; break;
                                                    case BEND_TYPE.ClassicRunner_Z_Positive: bendRotationAxis = Vector3.back; break;
                                                    case BEND_TYPE.ClassicRunner_Z_Negative: bendRotationAxis = Vector3.forward; break;
                                                }
                                            }
                                            else
                                            {
                                                bendRotationAxis = bendPivotPoint.forward;
                                            }
                                        }
                                        break;

                                    case AXIS_TYPE.Custom:
                                        break;

                                    case AXIS_TYPE.CustomNormalized:
                                        bendRotationAxis = bendRotationAxis.normalized;
                                        break;
                                }

                                Shader.SetGlobalVector(materialPropertyID_PivotPoint, bendPivotPointPosition);
                                Shader.SetGlobalVector(materialPropertyID_RotationAxis, bendRotationAxis);
                                Shader.SetGlobalVector(materialPropertyID_BendSize, new Vector3(bendCurvatureSize, bendVerticalSize, bendHorizontalSize));
                                Shader.SetGlobalVector(materialPropertyID_BendOffset, new Vector3(bendCurvatureOffset, bendVerticalOffset, bendHorizontalOffset));
                            }
                            break;
                    }
                }
            }
        }

        void UpdateShaderDataDisabled()
        {
            switch (bendType)
            {
                case BEND_TYPE.ClassicRunner_X_Positive:
                case BEND_TYPE.ClassicRunner_X_Negative:
                case BEND_TYPE.ClassicRunner_Z_Positive:
                case BEND_TYPE.ClassicRunner_Z_Negative:
                    {
                        Shader.SetGlobalVector(materialPropertyID_PivotPoint, Vector3.zero);
                        Shader.SetGlobalVector(materialPropertyID_BendSize, Vector2.zero);
                        Shader.SetGlobalVector(materialPropertyID_BendOffset, Vector2.zero);
                    }
                    break;


                case BEND_TYPE.LittlePlanet_X:
                case BEND_TYPE.LittlePlanet_Y:
                case BEND_TYPE.LittlePlanet_Z:

                case BEND_TYPE.CylindricalTower_X:
                case BEND_TYPE.CylindricalTower_Z:

                case BEND_TYPE.CylindricalRolloff_X:
                case BEND_TYPE.CylindricalRolloff_Z:
                    {
                        Shader.SetGlobalVector(materialPropertyID_PivotPoint, Vector3.zero);
                        Shader.SetGlobalFloat(materialPropertyID_BendSize, 0);
                        Shader.SetGlobalFloat(materialPropertyID_BendOffset, 0);
                    }
                    break;


                case BEND_TYPE.SpiralHorizontal_X_Positive:
                case BEND_TYPE.SpiralHorizontal_X_Negative:
                case BEND_TYPE.SpiralHorizontal_Z_Positive:
                case BEND_TYPE.SpiralHorizontal_Z_Negative:

                case BEND_TYPE.SpiralVertical_X_Positive:
                case BEND_TYPE.SpiralVertical_X_Negative:
                case BEND_TYPE.SpiralVertical_Z_Positive:
                case BEND_TYPE.SpiralVertical_Z_Negative:
                    {
                        Shader.SetGlobalVector(materialPropertyID_PivotPoint, Vector3.zero);
                        Shader.SetGlobalVector(materialPropertyID_RotationCenter, Vector3.zero);
                        Shader.SetGlobalFloat(materialPropertyID_BendAngle, 0);
                        Shader.SetGlobalFloat(materialPropertyID_BendMinimumRadius, 0);
                    }
                    break;


                case BEND_TYPE.SpiralHorizontalDouble_X:
                case BEND_TYPE.SpiralHorizontalDouble_Z:

                case BEND_TYPE.SpiralVerticalDouble_X:
                case BEND_TYPE.SpiralVerticalDouble_Z:
                    {
                        Shader.SetGlobalVector(materialPropertyID_PivotPoint, Vector3.zero);
                        Shader.SetGlobalVector(materialPropertyID_RotationCenter, Vector3.zero);
                        Shader.SetGlobalVector(materialPropertyID_RotationCenter2, Vector3.zero);
                        Shader.SetGlobalVector(materialPropertyID_BendAngle, Vector2.zero);
                        Shader.SetGlobalVector(materialPropertyID_BendMinimumRadius, Vector2.zero);
                    }
                    break;


                case BEND_TYPE.SpiralHorizontalRolloff_X:
                case BEND_TYPE.SpiralHorizontalRolloff_Z:

                case BEND_TYPE.SpiralVerticalRolloff_X:
                case BEND_TYPE.SpiralVerticalRolloff_Z:
                    {
                        Shader.SetGlobalVector(materialPropertyID_PivotPoint, Vector3.zero);
                        Shader.SetGlobalVector(materialPropertyID_RotationCenter, Vector3.zero);
                        Shader.SetGlobalFloat(materialPropertyID_BendAngle, 0);
                        Shader.SetGlobalFloat(materialPropertyID_BendMinimumRadius, 0);
                        Shader.SetGlobalFloat(materialPropertyID_BendRolloff, 0);
                    }
                    break;


                case BEND_TYPE.TwistedSpiral_X_Positive:
                case BEND_TYPE.TwistedSpiral_X_Negative:
                case BEND_TYPE.TwistedSpiral_Z_Positive:
                case BEND_TYPE.TwistedSpiral_Z_Negative:
                    {
                        Shader.SetGlobalVector(materialPropertyID_PivotPoint, Vector3.zero);
                        Shader.SetGlobalVector(materialPropertyID_RotationAxis, Vector3.zero);
                        Shader.SetGlobalVector(materialPropertyID_BendSize, Vector3.zero);
                        Shader.SetGlobalVector(materialPropertyID_BendOffset, Vector3.zero);
                    }
                    break;


                default:
                    break;
            }
        }


        public void DisableBend()
        {
            GenerateShaderPropertyIDs();

            UpdateShaderDataDisabled();
        }

        public void EnableBend()
        {
            GenerateShaderPropertyIDs();


            previousBentType = bendType;
            previousID = bendID;

            UpdateShaderdata();
        }


        public void ManualUpdate()
        {
            UpdateShaderdata();
        }


        void CheckBendChanging()
        {
            if (previousBentType != bendType || previousID != bendID)
            {
                DisableBend();


                previousBentType = bendType;

                if (bendID < 1) bendID = 1;
                previousID = bendID;


                GenerateShaderPropertyIDs();
            }
        }

        void GenerateShaderPropertyIDs()
        {
            materialPropertyID_PivotPoint = Shader.PropertyToID(string.Format("CurvedWorld_{0}_ID{1}_PivotPoint", bendType, bendID));
            materialPropertyID_RotationCenter = Shader.PropertyToID(string.Format("CurvedWorld_{0}_ID{1}_RotationCenter", bendType, bendID));
            materialPropertyID_RotationCenter2 = Shader.PropertyToID(string.Format("CurvedWorld_{0}_ID{1}_RotationCenter2", bendType, bendID));
            materialPropertyID_RotationAxis = Shader.PropertyToID(string.Format("CurvedWorld_{0}_ID{1}_RotationAxis", bendType, bendID));
            materialPropertyID_BendSize = Shader.PropertyToID(string.Format("CurvedWorld_{0}_ID{1}_BendSize", bendType, bendID));
            materialPropertyID_BendOffset = Shader.PropertyToID(string.Format("CurvedWorld_{0}_ID{1}_BendOffset", bendType, bendID));
            materialPropertyID_BendAngle = Shader.PropertyToID(string.Format("CurvedWorld_{0}_ID{1}_BendAngle", bendType, bendID));
            materialPropertyID_BendMinimumRadius = Shader.PropertyToID(string.Format("CurvedWorld_{0}_ID{1}_BendMinimumRadius", bendType, bendID));
            materialPropertyID_BendRolloff = Shader.PropertyToID(string.Format("CurvedWorld_{0}_ID{1}_BendRolloff", bendType, bendID));
        }


        public Vector3 TransformPosition(Vector3 vertex)
        {
            if (enabled == false || gameObject.activeSelf == false)
                return vertex;
            else
                return CurvedWorldUtilities.TransformPosition(vertex, this);
        }

        public Quaternion TransformRotation(Vector3 vertex, Vector3 forwardVector, Vector3 rightVector)
        {
            Vector3 p0 = TransformPosition(vertex);
            Vector3 p1 = TransformPosition(vertex + forwardVector);
            Vector3 p2 = TransformPosition(vertex + rightVector);


            Vector3 forward = Vector3.Normalize(p1 - p0);
            Vector3 right = Vector3.Normalize(p2 - p0);
            Vector3 up = Vector3.Cross(forward, right);

            if (forward.sqrMagnitude < 0.01f && up.sqrMagnitude < 0.01f)
                return Quaternion.identity;
            else
                return Quaternion.LookRotation(forward, up);
        }


        public void SetBendVerticalSize(float value)
        {
            bendVerticalSize = value;
        }

        public void SetBendVerticalOffset(float value)
        {
            bendVerticalOffset = value;
        }

        public void SetBendHorizontalSize(float value)
        {
            bendHorizontalSize = value;
        }

        public void SetBendHorizontalOffset(float value)
        {
            bendHorizontalOffset = value;
        }

        public void SetBendCurvatureSize(float value)
        {
            bendCurvatureSize = value;
        }

        public void SetBendCurvatureOffset(float value)
        {
            bendCurvatureOffset = value;
        }

        public void SetBendAngle(float value)
        {
            bendAngle = value;
        }

        public void SetBendAngle2(float value)
        {
            bendAngle2 = value;
        }

        public void SetBendMinimumRadius(float value)
        {
            bendMinimumRadius = value;
        }

        public void SetBendMinimumRadius2(float value)
        {
            bendMinimumRadius2 = value;
        }

        public void SetBendRolloff(float value)
        {
            bendRolloff = value;
        }
    }
}