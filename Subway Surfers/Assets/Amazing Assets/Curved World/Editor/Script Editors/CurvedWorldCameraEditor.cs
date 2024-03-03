using UnityEngine;
using UnityEditor;


namespace AmazingAssets.CurvedWorldEditor
{
    [CustomEditor(typeof(CurvedWorld.CurvedWorldCamera))]
    [CanEditMultipleObjects]
    public class CurvedWorldCameraEditor : Editor
    {
        #region Component Menu
        [MenuItem("Component/Amazing Assets/Curved World/Camera", false, 512)]
        static public void AddComponent()
        {
            if (Selection.gameObjects != null && Selection.gameObjects.Length > 1)
            {
                for (int i = 0; i < Selection.gameObjects.Length; i++)
                {
                    if (Selection.gameObjects[i] != null)
                        Selection.gameObjects[i].AddComponent<CurvedWorld.CurvedWorldCamera>();
                }
            }
            else if (Selection.activeGameObject != null)
            {
                Selection.activeGameObject.AddComponent<CurvedWorld.CurvedWorldCamera>();
            }
        }

        [MenuItem("Component/Amazing Assets/Curved World/Camera", true)]
        static public bool ValidateAddComponent()
        {
            return (Selection.gameObjects == null || Selection.gameObjects.Length == 0) ? false : true;
        }
        #endregion


        #region Variables
        SerializedProperty matrixType;
        SerializedProperty fieldOfView;
        SerializedProperty size;
        SerializedProperty nearClipPlaneSameAsCamera;
        SerializedProperty nearClipPlane;
        SerializedProperty visualizeInEditor;
        #endregion


        #region Unity Functions
        void OnEnable()
        {
            matrixType = serializedObject.FindProperty("matrixType");
            fieldOfView = serializedObject.FindProperty("fieldOfView");
            size = serializedObject.FindProperty("size");
            nearClipPlaneSameAsCamera = serializedObject.FindProperty("nearClipPlaneSameAsCamera");
            nearClipPlane = serializedObject.FindProperty("nearClipPlane");
            visualizeInEditor = serializedObject.FindProperty("visualizeInEditor");
        }

        public override void OnInspectorGUI()
        {
            serializedObject.Update();


            GUILayout.Space(5);
            EditorGUILayout.PropertyField(matrixType);

            if (matrixType.enumValueIndex == (int)CurvedWorld.CurvedWorldCamera.MATRIX_TYPE.Perspective)
                EditorGUILayout.PropertyField(fieldOfView);
            else
                EditorGUILayout.PropertyField(size);

            if (matrixType.enumValueIndex == (int)CurvedWorld.CurvedWorldCamera.MATRIX_TYPE.Orthographic)
            {
                nearClipPlaneSameAsCamera.boolValue = EditorGUILayout.IntPopup("Near Clip Plane", nearClipPlaneSameAsCamera.boolValue ? 1 : 0, new string[] { "Custom", "Same As Camera" }, new int[] { 0, 1 }) == 1 ? true : false;
                if (nearClipPlaneSameAsCamera.boolValue == false)
                {
                    using (new EditorGUIHelper.EditorGUIIndentLevel(1))
                    {
                        EditorGUILayout.PropertyField(nearClipPlane, new GUIContent("Value"));
                    }
                }
            }


            EditorGUILayout.PropertyField(visualizeInEditor);


            serializedObject.ApplyModifiedProperties();
        }
        #endregion
    }
}