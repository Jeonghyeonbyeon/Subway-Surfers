using UnityEngine;
using UnityEditor;


namespace AmazingAssets.CurvedWorldEditor
{
    class CurvedWorldBendSettingsEditorWindow : EditorWindow
    {
        enum NORMAL_TRANSFORM { Default, Enable, Disable }


        public delegate void DataChanged(CurvedWorld.BEND_TYPE bendType, int bendID, int normalTransformState, object obj);
        static DataChanged callback;


        static public CurvedWorldBendSettingsEditorWindow window;

        
        CurvedWorld.BEND_TYPE bendType;
        int bendID;
        NORMAL_TRANSFORM normalTransform;


        static object objMaterial;
        static Vector2 windowResolution = new Vector2(340, 120);



        static public void ShowWindow(Vector2 position, DataChanged method, object obj)
        {
            if (window != null)
            {
                window.Close();
                window = null;
            }


            window = (CurvedWorldBendSettingsEditorWindow)CurvedWorldBendSettingsEditorWindow.CreateInstance(typeof(CurvedWorldBendSettingsEditorWindow));
            window.titleContent = new GUIContent("Bend Settings");

            callback = method;
            objMaterial = obj;


            window.minSize = windowResolution;
            window.maxSize = windowResolution;

            window.ShowUtility();
            window.position = new Rect(position.x, position.y, windowResolution.x, windowResolution.y);
        }

        void OnLostFocus()
        {
            if (window != null)
            {
                window.Close();
                window = null;
            }
        }

        void OnGUI()
        {
            if (callback == null ||
               (window != null && this != window))
                this.Close();


            using (new EditorGUIHelper.EditorGUILayoutBeginVertical(EditorStyles.helpBox))
            {
                Rect drawRect = EditorGUILayout.GetControlRect();

                #region BendType
                Rect rc = drawRect;
                rc.width = 140;
                EditorGUI.LabelField(rc, "Bend Type");

                rc.xMin = rc.xMax;
                rc.xMax = drawRect.xMax;
                if (GUI.Button(rc, EditorUtilities.GetBendTypeNameInfo(bendType).forLable, EditorStyles.popup))
                {
                    GenericMenu menu = EditorUtilities.BuildBendTypesMenu(bendType, CallbackBendTypeMenu);

                    menu.DropDown(new Rect(rc.xMin, rc.yMin, rc.width, UnityEditor.EditorGUIUtility.singleLineHeight));
                }
                #endregion


                #region BendID

                drawRect = EditorGUILayout.GetControlRect();

                rc = drawRect;
                rc.width = 140;
                EditorGUI.LabelField(rc, "Bend ID");

                rc.xMin = rc.xMax;
                rc.xMax = drawRect.xMax;
                bendID = EditorGUI.IntSlider(rc, bendID, 1, EditorUtilities.MAX_SUPPORTED_BEND_IDS);
                #endregion


                #region Transorm Normal 

                drawRect = EditorGUILayout.GetControlRect();

                rc = drawRect;
                rc.width = 140;
                EditorGUI.LabelField(rc, "Transform Normal");

                rc.xMin = rc.xMax;
                rc.xMax = drawRect.xMax;
                normalTransform = (NORMAL_TRANSFORM)EditorGUI.EnumPopup(rc, normalTransform);
                #endregion


                GUILayout.Space(32);
                using (new EditorGUIHelper.EditorGUILayoutBeginHorizontal())
                {
                    if (GUILayout.Button("Change"))
                    {
                        if (callback != null)
                            callback(bendType, bendID, (int)normalTransform, objMaterial);

                        this.Close();
                    }


                    if (GUILayout.Button("Cancel"))
                    {
                        this.Close();
                    }
                }
            }
        }


        void CallbackBendTypeMenu(object obj)
        {
            bendType = (CurvedWorld.BEND_TYPE)obj;
        }
    }
}