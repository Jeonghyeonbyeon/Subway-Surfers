using UnityEngine;
using UnityEditor;


namespace AmazingAssets.CurvedWorldEditor
{
    [CustomEditor(typeof(CurvedWorld.CurvedWorldBoundingBox))]
    [CanEditMultipleObjects]
    public class CurvedWorldBoundingBoxEditor : Editor
    {
        #region Component Menu
        [MenuItem("Component/Amazing Assets/Curved World/Bounding Box", false, 513)]
        static public void AddComponent()
        {
            if (Selection.gameObjects != null && Selection.gameObjects.Length > 1)
            {
                for (int i = 0; i < Selection.gameObjects.Length; i++)
                {
                    if (Selection.gameObjects[i] != null)
                        Selection.gameObjects[i].AddComponent<CurvedWorld.CurvedWorldBoundingBox>();
                }
            }
            else if (Selection.activeGameObject != null)
            {
                Selection.activeGameObject.AddComponent<CurvedWorld.CurvedWorldBoundingBox>();
            }
        }

        [MenuItem("Component/Amazing Assets/Curved World/Boundung Box", true)]
        static public bool ValidateAddComponent()
        {
            return (Selection.gameObjects == null || Selection.gameObjects.Length == 0) ? false : true;
        }
        #endregion


        #region Variables
        SerializedProperty scale;
        SerializedProperty visualizeInEditor;
        #endregion


        #region Unity Functions
        void OnEnable()
        {
            scale = serializedObject.FindProperty("scale");
            visualizeInEditor = serializedObject.FindProperty("visualizeInEditor");
        }

        public override void OnInspectorGUI()
        {
            serializedObject.Update();


            GUILayout.Space(5);
            using (new EditorGUIHelper.EditorGUILayoutBeginHorizontal())
            {
                EditorGUILayout.PropertyField(scale);

                if (GUILayout.Button("Recalculate", GUILayout.MaxWidth(90)))
                {
                    ((CurvedWorld.CurvedWorldBoundingBox)target).RecalculateBounds();
                }
            }
            EditorGUILayout.PropertyField(visualizeInEditor);

            if (scale.floatValue < 1)
                scale.floatValue = 1;


            serializedObject.ApplyModifiedProperties();
        }
        #endregion
    }
}