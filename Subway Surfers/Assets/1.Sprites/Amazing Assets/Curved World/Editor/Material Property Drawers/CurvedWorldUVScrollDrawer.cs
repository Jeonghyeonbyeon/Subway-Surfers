using UnityEngine;
using UnityEditor;


namespace AmazingAssets.CurvedWorldEditor
{
    class CurvedWorldUVScrollDrawer : MaterialPropertyDrawer
    {
        public override void OnGUI(Rect position, MaterialProperty prop, string label, MaterialEditor editor)
        {

            Vector2 vector = prop.vectorValue;

            EditorGUI.BeginChangeCheck();
            vector = TextureScaleOffsetProperty(position, vector, new GUIContent("Scroll"));
            if (EditorGUI.EndChangeCheck())
            {
                prop.vectorValue = vector;
            }
        }

        static Vector2 TextureScaleOffsetProperty(Rect position, Vector2 scroll, GUIContent label)
        {
            float kLineHeight = 18;


            Vector2 vector2_1 = new Vector2(scroll.x, scroll.y);
            float width = UnityEditor.EditorGUIUtility.labelWidth;
            float x1 = position.x + width;
            float x2 = position.x + EditorGUI.indentLevel * 15f;
            int indentLevel = EditorGUI.indentLevel;
            EditorGUI.indentLevel = 0;
            Rect totalPosition = new Rect(x2, position.y, width, kLineHeight);
            Rect position1 = new Rect(x1, position.y, position.width - width, kLineHeight);
            EditorGUI.PrefixLabel(totalPosition, label);
            Vector2 vector2_3 = EditorGUI.Vector2Field(position1, GUIContent.none, vector2_1);

            EditorGUI.indentLevel = indentLevel;

            return new Vector2(vector2_3.x, vector2_3.y);
        }
    }
}