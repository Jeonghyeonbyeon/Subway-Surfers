using System;

using UnityEngine;
using UnityEditor;


namespace AmazingAssets.CurvedWorldEditor
{
    static internal class EditorGUIHelper 
    {
        #region GUI
        public class GUIEnabled : IDisposable
        {
            [SerializeField]
            private bool PreviousState
            {
                get;
                set;
            }

            public GUIEnabled(bool newState)
            {
                PreviousState = GUI.enabled;
                if (PreviousState == false)
                    GUI.enabled = false;
                else
                    GUI.enabled = newState;
            }

            public void Dispose()
            {
                GUI.enabled = PreviousState;
            }
        }

        public class GUIColor : IDisposable
        {
            [SerializeField]
            private Color PreviousColor
            {
                get;
                set;
            }

            public GUIColor(Color newColor)
            {
                PreviousColor = GUI.color;
                GUI.color = newColor;
            }

            public void Dispose()
            {
                GUI.color = PreviousColor;
            }
        }

        public class GUIBackgroundColor : IDisposable
        {
            [SerializeField]
            private Color PreviousColor
            {
                get;
                set;
            }

            public GUIBackgroundColor(Color newColor)
            {
                PreviousColor = GUI.color;
                GUI.backgroundColor = newColor;
            }

            public void Dispose()
            {
                GUI.backgroundColor = PreviousColor;
            }
        }

        public class GUISkinLabelFontStyle : IDisposable
        {
            [SerializeField]
            private FontStyle PreviousStyle
            {
                set;
                get;
            }

            public GUISkinLabelFontStyle(FontStyle newStyle)
            {
                PreviousStyle = GUI.skin.label.fontStyle;
                GUI.skin.label.fontStyle = newStyle;
            }

            public void Dispose()
            {
                GUI.skin.label.fontStyle = PreviousStyle;
            }
        }

        public class GUISkinLabelNormalTextColor : IDisposable
        {
            [SerializeField]
            private Color PreviousTextColor
            {
                set;
                get;
            }

            public GUISkinLabelNormalTextColor(Color newColor)
            {
                PreviousTextColor = GUI.skin.label.normal.textColor;
                GUI.skin.label.normal.textColor = newColor;
            }

            public void Dispose()
            {
                GUI.skin.label.normal.textColor = PreviousTextColor;
            }
        }
        #endregion


        #region GUI Layout
        public class GUILayoutBeginHorizontal : IDisposable
        {
            public GUILayoutBeginHorizontal()
            {
                GUILayout.BeginHorizontal();
            }

            public GUILayoutBeginHorizontal(params GUILayoutOption[] layoutOptions)
            {
                GUILayout.BeginHorizontal(layoutOptions);
            }

            public GUILayoutBeginHorizontal(GUIStyle style, params GUILayoutOption[] options)
            {
                GUILayout.BeginHorizontal(style, options);
            }

            public GUILayoutBeginHorizontal(string text, GUIStyle style, params GUILayoutOption[] options)
            {
                GUILayout.BeginHorizontal(text, style, options);
            }

            public void Dispose()
            {
                GUILayout.EndHorizontal();
            }
        }

        public class GUILayoutBeginVertical : IDisposable
        {
            public GUILayoutBeginVertical()
            {
                GUILayout.BeginVertical();
            }

            public GUILayoutBeginVertical(params GUILayoutOption[] options)
            {
                GUILayout.BeginVertical(options);
            }

            public GUILayoutBeginVertical(GUIStyle style, params GUILayoutOption[] options)
            {
                GUILayout.BeginVertical(style, options);
            }

            public GUILayoutBeginVertical(string text, GUIStyle style, params GUILayoutOption[] options)
            {
                GUILayout.BeginVertical(text, style, options);
            }

            public void Dispose()
            {
                GUILayout.EndVertical();
            }
        }
        #endregion


        #region Editor GUI
        public class EditorGUIIndentLevel : IDisposable
        {
            [SerializeField]
            private int PreviousIndent
            {
                get;
                set;
            }

            public EditorGUIIndentLevel(int newIndent)
            {
                PreviousIndent = EditorGUI.indentLevel;
                EditorGUI.indentLevel = EditorGUI.indentLevel + newIndent;
            }

            public void Dispose()
            {
                EditorGUI.indentLevel = PreviousIndent;
            }
        }

        public class EditorGUIUtilityLabelWidth : IDisposable
        {
            [SerializeField]
            private float PreviousWidth
            {
                get;
                set; 
            }

            public EditorGUIUtilityLabelWidth(float newWidth)
            {
                PreviousWidth = UnityEditor.EditorGUIUtility.labelWidth;
                UnityEditor.EditorGUIUtility.labelWidth = newWidth;
            }

            public void Dispose()
            {
                UnityEditor.EditorGUIUtility.labelWidth = PreviousWidth;
            }
        }

        public class EditorGUIUtilityFieldWidth : IDisposable
        {
            [SerializeField]
            private float PreviousWidth
            {
                get;
                set;
            }

            public EditorGUIUtilityFieldWidth(float newWidth)
            {
                PreviousWidth = UnityEditor.EditorGUIUtility.fieldWidth;
                UnityEditor.EditorGUIUtility.fieldWidth = newWidth;
            }

            public void Dispose()
            {
                UnityEditor.EditorGUIUtility.fieldWidth = PreviousWidth;
            }
        }
        #endregion


        #region Editor GUI Layout
        public class EditorGUILayoutBeginHorizontal : IDisposable
        {
            public EditorGUILayoutBeginHorizontal()
            {
                EditorGUILayout.BeginHorizontal();
            }

            public EditorGUILayoutBeginHorizontal(params GUILayoutOption[] options)
            {
                EditorGUILayout.BeginHorizontal(options);
            }

            public EditorGUILayoutBeginHorizontal(GUIStyle style, params GUILayoutOption[] options)
            {
                EditorGUILayout.BeginHorizontal(style, options);
            }

            public void Dispose()
            {
                EditorGUILayout.EndHorizontal();
            }
        }

        public class EditorGUILayoutBeginVertical : IDisposable
        {
            public EditorGUILayoutBeginVertical()
            {
                EditorGUILayout.BeginVertical();
            }

            public EditorGUILayoutBeginVertical(params GUILayoutOption[] options)
            {
                EditorGUILayout.BeginVertical(options);
            }

            public EditorGUILayoutBeginVertical(GUIStyle style, params GUILayoutOption[] options)
            {
                EditorGUILayout.BeginVertical(style, options);
            }

            public void Dispose()
            {
                EditorGUILayout.EndVertical();
            }
        }
        #endregion



        internal static bool ToggleAsButton(Rect rect, bool value, string label, bool hasError = false, bool hasWarning = false)
        {
            using (new EditorGUIHelper.GUIBackgroundColor(hasError ? Color.red : (hasWarning ? Color.yellow : GetToggleButtonColor(value))))
            {
                return GUI.Toggle(rect, value, label, "Button");
            }
        }

        internal static Color GetToggleButtonColor(bool isEnabled)
        {
            return (UnityEditor.EditorGUIUtility.isProSkin && isEnabled == true) ? Color.green * 0.6f : Color.white;
        }
    }
}