using UnityEngine;
using UnityEditor;


namespace AmazingAssets.CurvedWorldEditor
{
    [CustomEditor(typeof(CurvedWorld.CurvedWorldController))]
    public class CurvedWorldControllerEditor : Editor
    {
        #region Component Menu
        [MenuItem("Component/Amazing Assets/Curved World/Controller", false, 511)]
        static public void AddComponent()
        {
            if (Selection.gameObjects != null && Selection.gameObjects.Length > 1)
            {
                for (int i = 0; i < Selection.gameObjects.Length; i++)
                {
                    if (Selection.gameObjects[i] != null)
                        Selection.gameObjects[i].AddComponent<CurvedWorld.CurvedWorldController>();
                }
            }
            else if (Selection.activeGameObject != null)
            {
                Selection.activeGameObject.AddComponent<CurvedWorld.CurvedWorldController>();
            }
        }

        [MenuItem("Component/Amazing Assets/Curved World/Controller", true)]
        static public bool ValidateAddComponent()
        {
            return (Selection.gameObjects == null || Selection.gameObjects.Length == 0) ? false : true;
        }
        #endregion


        #region Variables
        public CurvedWorld.CurvedWorldController _target;

        SerializedProperty bendType;
        SerializedProperty bendID;
        SerializedProperty bendPivotPoint; SerializedProperty bendPivotPointPosition;
        SerializedProperty bendRotationCenter; SerializedProperty bendRotationCenterPosition; SerializedProperty bendRotationAxis; SerializedProperty bendRotationAxisType;
        SerializedProperty bendRotationCenter2; SerializedProperty bendRotationCenter2Position;

        SerializedProperty bendVerticalSize, bendVerticalOffset;
        SerializedProperty bendHorizontalSize, bendHorizontalOffset;
        SerializedProperty bendCurvatureSize, bendCurvatureOffset;

        SerializedProperty bendAngle;
        SerializedProperty bendAngle2;
        SerializedProperty bendMinimumRadius;
        SerializedProperty bendMinimumRadius2;
        SerializedProperty bendRolloff;

        SerializedProperty disableInEditor;
        SerializedProperty manualUpdate;
        #endregion


        #region Unity Functions
        void OnEnable()
        {
            try
            {
                _target = (CurvedWorld.CurvedWorldController)target;
            }
            catch
            {

                _target = null;
            }



            if (_target == null || serializedObject == null)
            {
                //do nothing
            }
            else
                LoadProperties();
        }

        public override void OnInspectorGUI()
        {
            if (_target == null)
                return;

            serializedObject.Update();


            using (new EditorGUIHelper.GUIEnabled(_target.isActiveAndEnabled))
            {
                GUILayout.Space(5);

                DrawLabelHeader("Curved World Method Identifier");

                using (new EditorGUIHelper.EditorGUILayoutBeginHorizontal())
                {
                    EditorGUILayout.LabelField("  Bend Type");
                    Rect rc = GUILayoutUtility.GetLastRect();
                    rc.xMin += UnityEditor.EditorGUIUtility.labelWidth;
                    if (GUI.Button(rc, EditorUtilities.GetBendTypeNameInfo(_target.bendType).forLable, EditorStyles.popup))
                    {
                        GenericMenu menu = EditorUtilities.BuildBendTypesMenu(_target.bendType, MenuCallbackBendType);

                        menu.DropDown(new Rect(rc.xMin, rc.yMin, 200, UnityEditor.EditorGUIUtility.singleLineHeight));
                    }


                    if (CurvedWorldEditorWindow.activeWindow == null)
                    {
                        if (GUILayout.Button("Editor", GUILayout.MaxWidth(50)))
                        {
                            EditorUtilities.CallbackOpenCurvedWorldSettingsWindow(bendType.enumValueIndex + "_" + bendID.intValue);
                        }
                    }
                }

                EditorGUILayout.PropertyField(bendID, new GUIContent("  Bend ID"));
                if (bendID.intValue < 1) bendID.intValue = 1;




                #region Bend Controllers
                switch (_target.bendType)
                {
                    case CurvedWorld.BEND_TYPE.ClassicRunner_X_Positive:
                    case CurvedWorld.BEND_TYPE.ClassicRunner_X_Negative:
                    case CurvedWorld.BEND_TYPE.ClassicRunner_Z_Positive:
                    case CurvedWorld.BEND_TYPE.ClassicRunner_Z_Negative:
                        {
                            EditorGUILayout.BeginVertical();
                            GUILayout.Space(5);

                            Draw_PivotPoint();
                            GUILayout.Space(5);

                            DrawLabelHeader("Bend Settings");

                            Draw_BendSizeOffset(ref bendHorizontalSize, ref bendHorizontalOffset, "  Horizontal");
                            Draw_BendSizeOffset(ref bendVerticalSize, ref bendVerticalOffset, "  Vertical");

                            GUILayout.Space(5);
                            EditorGUILayout.EndVertical();

                        }
                        break;

                    case CurvedWorld.BEND_TYPE.TwistedSpiral_X_Positive:
                    case CurvedWorld.BEND_TYPE.TwistedSpiral_X_Negative:
                    case CurvedWorld.BEND_TYPE.TwistedSpiral_Z_Positive:
                    case CurvedWorld.BEND_TYPE.TwistedSpiral_Z_Negative:
                        {
                            EditorGUILayout.BeginVertical();
                            GUILayout.Space(5);

                            Draw_PivotPoint();
                            Draw_PivotPointAxis();
                            GUILayout.Space(5);

                            GUILayout.Space(5);
                            DrawLabelHeader("Bend Settings");

                            Draw_BendSizeOffset(ref bendCurvatureSize, ref bendCurvatureOffset, "  Curvature");
                            Draw_BendSizeOffset(ref bendHorizontalSize, ref bendHorizontalOffset, "  Horizontal");
                            Draw_BendSizeOffset(ref bendVerticalSize, ref bendVerticalOffset, "  Vertical");

                            GUILayout.Space(5);
                            EditorGUILayout.EndVertical();
                        }
                        break;

                    case CurvedWorld.BEND_TYPE.LittlePlanet_X:
                    case CurvedWorld.BEND_TYPE.LittlePlanet_Y:
                    case CurvedWorld.BEND_TYPE.LittlePlanet_Z:
                    case CurvedWorld.BEND_TYPE.CylindricalTower_X:
                    case CurvedWorld.BEND_TYPE.CylindricalTower_Z:
                    case CurvedWorld.BEND_TYPE.CylindricalRolloff_X:
                    case CurvedWorld.BEND_TYPE.CylindricalRolloff_Z:
                        {
                            EditorGUILayout.BeginVertical();
                            GUILayout.Space(5);

                            Draw_PivotPoint();
                            GUILayout.Space(5);

                            DrawLabelHeader("Bend Settings");

                            Draw_BendSizeOffset(ref bendCurvatureSize, ref bendCurvatureOffset, "  Curvature");

                            GUILayout.Space(5);
                            EditorGUILayout.EndVertical();
                        }
                        break;

                    case CurvedWorld.BEND_TYPE.SpiralHorizontal_X_Positive:
                    case CurvedWorld.BEND_TYPE.SpiralHorizontal_X_Negative:
                    case CurvedWorld.BEND_TYPE.SpiralHorizontal_Z_Positive:
                    case CurvedWorld.BEND_TYPE.SpiralHorizontal_Z_Negative:
                    case CurvedWorld.BEND_TYPE.SpiralVertical_X_Positive:
                    case CurvedWorld.BEND_TYPE.SpiralVertical_X_Negative:
                    case CurvedWorld.BEND_TYPE.SpiralVertical_Z_Positive:
                    case CurvedWorld.BEND_TYPE.SpiralVertical_Z_Negative:
                        {
                            EditorGUILayout.BeginVertical();
                            GUILayout.Space(5);

                            Draw_PivotPoint();

                            GUILayout.Space(5);
                            EditorGUILayout.EndVertical();


                            EditorGUILayout.BeginVertical();
                            GUILayout.Space(5);

                            Draw_RotationCenter();
                            Draw_AngleAndRadius(ref bendAngle, ref bendMinimumRadius);

                            GUILayout.Space(5);
                            EditorGUILayout.EndVertical();
                        }
                        break;

                    case CurvedWorld.BEND_TYPE.SpiralHorizontalDouble_X:
                    case CurvedWorld.BEND_TYPE.SpiralHorizontalDouble_Z:
                    case CurvedWorld.BEND_TYPE.SpiralVerticalDouble_X:
                    case CurvedWorld.BEND_TYPE.SpiralVerticalDouble_Z:
                        {
                            EditorGUILayout.BeginVertical();
                            GUILayout.Space(5);

                            Draw_PivotPoint();

                            GUILayout.Space(5);
                            EditorGUILayout.EndVertical();

                            EditorGUILayout.BeginVertical();
                            GUILayout.Space(5);

                            Draw_RotationCenter();
                            Draw_AngleAndRadius(ref bendAngle, ref bendMinimumRadius);

                            GUILayout.Space(5);
                            EditorGUILayout.EndVertical();

                            EditorGUILayout.BeginVertical();

                            Draw_RotationCenter2();
                            Draw_AngleAndRadius(ref bendAngle2, ref bendMinimumRadius2);

                            GUILayout.Space(5);
                            EditorGUILayout.EndVertical();
                        }
                        break;

                    case CurvedWorld.BEND_TYPE.SpiralHorizontalRolloff_X:
                    case CurvedWorld.BEND_TYPE.SpiralHorizontalRolloff_Z:
                    case CurvedWorld.BEND_TYPE.SpiralVerticalRolloff_X:
                    case CurvedWorld.BEND_TYPE.SpiralVerticalRolloff_Z:
                        {
                            EditorGUILayout.BeginVertical();
                            GUILayout.Space(5);

                            Draw_PivotPoint();

                            GUILayout.Space(5);
                            EditorGUILayout.EndVertical();


                            EditorGUILayout.BeginVertical();
                            GUILayout.Space(5);

                            Draw_RotationCenter();
                            Draw_AngleAndRadius(ref bendAngle, ref bendMinimumRadius);
                            Draw_Rolloff();

                            GUILayout.Space(5);
                            EditorGUILayout.EndVertical();

                        }
                        break;

                    default: break;
                }
                #endregion


                #region Editor helpers
                GUILayout.Space(5);
                DrawLabelHeader("Additional");

                EditorGUI.BeginChangeCheck();
                using (new EditorGUIHelper.GUIEnabled(Application.isPlaying == false))
                {
                    EditorGUILayout.PropertyField(disableInEditor, new GUIContent("  Disable In Editor"));
                }
                if (EditorGUI.EndChangeCheck())
                {
                    if (disableInEditor.boolValue == true)
                        _target.DisableBend();
                    else
                        _target.EnableBend();
                }

                EditorGUILayout.PropertyField(manualUpdate, new GUIContent("  Manual Update"));
                #endregion
            }

            serializedObject.ApplyModifiedProperties();


            GUILayout.Space(5);
        }
        #endregion


        void LoadProperties()
        {
            if (bendType == null)
                bendType = serializedObject.FindProperty("bendType");

            if (bendID == null)
                bendID = serializedObject.FindProperty("bendID");

            if (bendPivotPoint == null)
                bendPivotPoint = serializedObject.FindProperty("bendPivotPoint");
            if (bendPivotPointPosition == null)
                bendPivotPointPosition = serializedObject.FindProperty("bendPivotPointPosition");

            if (bendRotationCenter == null)
                bendRotationCenter = serializedObject.FindProperty("bendRotationCenter");
            if (bendRotationCenterPosition == null)
                bendRotationCenterPosition = serializedObject.FindProperty("bendRotationCenterPosition");
            if (bendRotationAxis == null)
                bendRotationAxis = serializedObject.FindProperty("bendRotationAxis");
            if (bendRotationAxisType == null)
                bendRotationAxisType = serializedObject.FindProperty("bendRotationAxisType");

            if (bendRotationCenter2 == null)
                bendRotationCenter2 = serializedObject.FindProperty("bendRotationCenter2");
            if (bendRotationCenter2Position == null)
                bendRotationCenter2Position = serializedObject.FindProperty("bendRotationCenter2Position");

            if (bendVerticalSize == null)
                bendVerticalSize = serializedObject.FindProperty("bendVerticalSize");

            if (bendVerticalOffset == null)
                bendVerticalOffset = serializedObject.FindProperty("bendVerticalOffset");

            if (bendHorizontalSize == null)
                bendHorizontalSize = serializedObject.FindProperty("bendHorizontalSize");

            if (bendHorizontalOffset == null)
                bendHorizontalOffset = serializedObject.FindProperty("bendHorizontalOffset");

            if (bendCurvatureSize == null)
                bendCurvatureSize = serializedObject.FindProperty("bendCurvatureSize");

            if (bendCurvatureOffset == null)
                bendCurvatureOffset = serializedObject.FindProperty("bendCurvatureOffset");

            if (bendAngle == null)
                bendAngle = serializedObject.FindProperty("bendAngle");

            if (bendAngle2 == null)
                bendAngle2 = serializedObject.FindProperty("bendAngle2");

            if (bendMinimumRadius == null)
                bendMinimumRadius = serializedObject.FindProperty("bendMinimumRadius");

            if (bendMinimumRadius2 == null)
                bendMinimumRadius2 = serializedObject.FindProperty("bendMinimumRadius2");

            if (bendRolloff == null)
                bendRolloff = serializedObject.FindProperty("bendRolloff");


            if (disableInEditor == null)
                disableInEditor = serializedObject.FindProperty("disableInEditor");

            if (manualUpdate == null)
                manualUpdate = serializedObject.FindProperty("manualUpdate");


            serializedObject.Update();
        }

        void Draw_PivotPoint()
        {
            DrawLabelHeader("Pivot Point");

            using (new EditorGUIHelper.EditorGUILayoutBeginHorizontal())
            {
                EditorGUILayout.PropertyField(bendPivotPoint, new GUIContent("  Transform"));

                if (bendPivotPoint.objectReferenceValue == null)
                {
                    if (GUILayout.Button("Create", GUILayout.MaxWidth(60)))
                    {
                        GameObject obj = new GameObject("Pivot Point");
                        obj.transform.position = _target.transform.position;

                        bendPivotPoint.objectReferenceValue = obj;
                    }
                }
            }

            using (new EditorGUIHelper.GUIEnabled(bendPivotPoint.objectReferenceValue == null))
            {
                DrawVector3(ref bendPivotPointPosition, "  Position");
            }
        }

        void Draw_RotationCenter()
        {
            string label = "Rotation Center";
            if (_target.bendType == CurvedWorld.BEND_TYPE.SpiralHorizontalDouble_X ||
                _target.bendType == CurvedWorld.BEND_TYPE.SpiralHorizontalDouble_Z ||
                _target.bendType == CurvedWorld.BEND_TYPE.SpiralVerticalDouble_X ||
                _target.bendType == CurvedWorld.BEND_TYPE.SpiralVerticalDouble_Z)
            {
                label += " #1";
            }

            DrawLabelHeader(label);

            using (new EditorGUIHelper.EditorGUILayoutBeginHorizontal())
            {
                EditorGUILayout.PropertyField(bendRotationCenter, new GUIContent("  Transform"));

                if (bendRotationCenter.objectReferenceValue == null)
                {
                    if (GUILayout.Button("Create", GUILayout.MaxWidth(60)))
                    {
                        GameObject obj = new GameObject(label);
                        obj.transform.position = _target.transform.position;

                        bendRotationCenter.objectReferenceValue = obj;
                    }
                }
            }

            using (new EditorGUIHelper.GUIEnabled(bendRotationCenter.objectReferenceValue == null))
            {
                DrawVector3(ref bendRotationCenterPosition, "  Position");
            }
        }

        void Draw_RotationCenter2()
        {
            DrawLabelHeader("Rotation Center #2");

            using (new EditorGUIHelper.EditorGUILayoutBeginHorizontal())
            {
                EditorGUILayout.PropertyField(bendRotationCenter2, new GUIContent("  Transform"));

                if (bendRotationCenter2.objectReferenceValue == null)
                {
                    if (GUILayout.Button("Create", GUILayout.MaxWidth(60)))
                    {
                        GameObject obj = new GameObject("Rotation Center #2");
                        obj.transform.position = _target.transform.position;

                        bendRotationCenter2.objectReferenceValue = obj;
                    }
                }
            }

            using (new EditorGUIHelper.GUIEnabled(bendRotationCenter2.objectReferenceValue == null))
            {
                DrawVector3(ref bendRotationCenter2Position, "  Position");
            }
        }

        void Draw_PivotPointAxis()
        {
            //Axis
            using (new EditorGUIHelper.GUIEnabled(bendRotationAxisType.enumValueIndex != (int)CurvedWorld.CurvedWorldController.AXIS_TYPE.Transform))
            {
                using (new EditorGUIHelper.GUIBackgroundColor(bendRotationAxis.vector3Value.magnitude <= 0.0001f ? Color.red : Color.white))
                {
                    DrawVector3(ref bendRotationAxis, " ");
                }
            }

            Rect position = GUILayoutUtility.GetLastRect();
            position.xMax = UnityEditor.EditorGUIUtility.labelWidth;

            int axisType = bendRotationAxisType.enumValueIndex;
            EditorGUI.BeginChangeCheck();
            axisType = EditorGUI.Popup(position, axisType, new string[] { "Axis (Transform)", "Axis (Custom)", "Axis (Normalized)" });
            if (EditorGUI.EndChangeCheck())
            {
                bendRotationAxisType.enumValueIndex = axisType;
                Repaint();
            }

        }


        void Draw_BendSizeOffset(ref SerializedProperty propSize, ref SerializedProperty propOffset, string axisLabel)
        {
            EditorGUILayout.LabelField(axisLabel);

            Rect position = GUILayoutUtility.GetLastRect();
            position.xMin += UnityEditor.EditorGUIUtility.labelWidth;



            float bSize = propSize.floatValue;
            float bOffset = propOffset.floatValue;


            EditorGUI.BeginChangeCheck();
            using (new EditorGUIHelper.EditorGUIUtilityLabelWidth(28))
            {
                bSize = EditorGUI.FloatField(new Rect(position.x, position.y, position.width / 2 - 6, position.height), "Size", bSize);
            }
            using (new EditorGUIHelper.EditorGUIUtilityLabelWidth(40))
            {
                bOffset = EditorGUI.FloatField(new Rect(position.x + position.width / 2 - 3, position.y, position.width / 2 + 3, position.height), "Offset", bOffset);
            }
            if (EditorGUI.EndChangeCheck())
            {
                propSize.floatValue = bSize;
                propOffset.floatValue = bOffset;
            }
        }

        void Draw_AngleAndRadius(ref SerializedProperty bAngle, ref SerializedProperty bMinRadius)
        {
            float angle = bAngle.floatValue;
            float minimumRadius = bMinRadius.floatValue;

            EditorGUI.BeginChangeCheck();
            angle = EditorGUILayout.FloatField("  Angle", angle);
            minimumRadius = EditorGUILayout.FloatField("  Minimum Radius", minimumRadius);

            if (EditorGUI.EndChangeCheck())
            {
                if (angle < 0) angle = 0;
                if (minimumRadius < 0) minimumRadius = 0;

                bAngle.floatValue = angle;
                bMinRadius.floatValue = minimumRadius;
            }
        }

        void Draw_Rolloff()
        {
            EditorGUILayout.PropertyField(bendRolloff, new GUIContent("  Rolloff"));

            if (bendRolloff.floatValue < 0)
                bendRolloff.floatValue = 0;

        }

        void DrawLabelHeader(string label)
        {
            EditorGUILayout.LabelField(label, EditorStyles.miniLabel);

            Rect drawRect = GUILayoutUtility.GetLastRect();

            Color lineColor = UnityEditor.EditorGUIUtility.isProSkin ? Color.gray * 0.75f : Color.gray * 0.3f;

            EditorGUI.DrawRect(new Rect(drawRect.xMin, drawRect.yMax - 1, drawRect.width, 1), lineColor);
        }

        void DrawVector3(ref SerializedProperty prop, string label)
        {
            EditorGUILayout.LabelField(label);


            Vector3 value = prop.vector3Value;

            Rect drawRect = GUILayoutUtility.GetLastRect();
            drawRect.xMin = UnityEditor.EditorGUIUtility.labelWidth + 20;

            EditorGUI.BeginChangeCheck();
            value = EditorGUI.Vector3Field(drawRect, string.Empty, value);
            if (EditorGUI.EndChangeCheck())
            {
                prop.vector3Value = value;
            }

        }

        void MenuCallbackBendType(object obj)
        {
            CurvedWorld.BEND_TYPE newBendType = (CurvedWorld.BEND_TYPE)obj;

            Undo.RecordObject(_target, "Change Bend Type");

            _target.DisableBend();
            _target.bendType = newBendType;

            UnityEditor.EditorUtility.SetDirty(_target);
        }
    }
}