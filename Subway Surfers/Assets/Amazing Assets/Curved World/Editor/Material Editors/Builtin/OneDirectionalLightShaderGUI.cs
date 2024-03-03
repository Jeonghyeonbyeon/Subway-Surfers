using System.Linq;

using UnityEngine;
using UnityEditor;


namespace AmazingAssets.CurvedWorldEditor
{
    internal class OneDirectionalLightShaderGUI : ShaderGUI
    {
        static MaterialProperty _AmbientLights = null;
        static MaterialProperty _PerVertexLights = null;

        static MaterialProperty _LightLookupTex = null;
        static MaterialProperty _LightLookupOffset = null;

        static MaterialProperty _IncludeVertexColor = null;
        static MaterialProperty _Color = null;
        static MaterialProperty _MainTex = null;
        static MaterialProperty _MainTex_Scroll = null;
        static MaterialProperty _Cutoff = null;

        static MaterialProperty _TextureMix = null;
        static MaterialProperty _SecondaryTex = null;
        static MaterialProperty _SecondaryTex_Scroll = null;
        static MaterialProperty _SecondaryTex_Blend = null;

        static MaterialProperty _NormalMapStrength = null;
        static MaterialProperty _NormalMap = null;
        static MaterialProperty _NormalMap_Scroll = null;
        static MaterialProperty _SecondaryNormalMap = null;
        static MaterialProperty _SecondaryNormalMap_Scroll = null;

        static MaterialProperty _SpecularColor = null;
        static MaterialProperty _Shininess = null;
        static MaterialProperty _SpecularMaskOffset = null;

        static MaterialProperty _ReflectionColor = null;
        static MaterialProperty _ReflectionMaskOffset = null;
        static MaterialProperty _ReflectionCubeMap = null;
        static MaterialProperty _ReflectionFresnelBias = null;

        static MaterialProperty _RimColor = null;
        static MaterialProperty _RimBias = null;

        static MaterialProperty _EmissionColor = null;
        static MaterialProperty _EmissionMap = null;
        static MaterialProperty _EmissionMap_Scroll = null;


        static MaterialProperty _OutlineColor = null;
        static MaterialProperty _OutlineWidth = null;
        static MaterialProperty _OutlineSizeIsFixed = null;


        static bool isOutline;


        public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
        {
            FindProperties(properties);

            isOutline = _OutlineColor != null;


            CurvedWorldEditor.MaterialProperties.InitCurvedWorldMaterialProperties(properties);
            CurvedWorldEditor.MaterialProperties.DrawCurvedWorldMaterialProperties(materialEditor, MaterialProperties.STYLE.HelpBox, isOutline ? false : true, true);


            Material material = (Material)materialEditor.target;



            materialEditor.ShaderProperty(_AmbientLights, "Ambient Lights");
            materialEditor.ShaderProperty(_PerVertexLights, "Per-Vertex Lights");

            DrawLightLookUp(materialEditor, material);
            DrawOutline(materialEditor, material);
            DrawAlbedo(materialEditor, material);
            DrawCutout(materialEditor, material);
            DrawBumpMap(materialEditor, material);
            DrawSpecular(materialEditor, material);
            DrawReflection(materialEditor, material);
            DrawRimFresnel(materialEditor, material);
            DrawEmission(materialEditor, material);


            GUILayout.Space(10);
            DrawHeader("Advanced Rendering Options");
            base.OnGUI(materialEditor, properties);
        }

        void DrawLightLookUp(MaterialEditor materialEditor, Material material)
        {
            bool value = material.shaderKeywords.Contains("_LIGHTLOOKUP");

            using (new EditorGUIHelper.EditorGUILayoutBeginVertical(EditorStyles.helpBox))
            {
                //Anchor
                EditorGUILayout.LabelField(string.Empty);
                Rect rect = GUILayoutUtility.GetLastRect();

                if (UnityEditor.EditorGUIUtility.isProSkin)
                    EditorGUI.DrawRect(new Rect(rect.xMin - 2, rect.yMin, rect.width + 4, rect.height), Color.white * 0.35f);


            EditorGUI.BeginChangeCheck();
            value = EditorGUI.ToggleLeft(rect, "Light Lookup (Toon Shading)", value, EditorStyles.boldLabel);
            if (EditorGUI.EndChangeCheck())
            {
                if (value)
                    material.EnableKeyword("_LIGHTLOOKUP");
                else
                    material.DisableKeyword("_LIGHTLOOKUP");
            }

            if (value)
            {
                using (new EditorGUIHelper.EditorGUIIndentLevel(1))
                {
                    materialEditor.TexturePropertySingleLine(new GUIContent("Lookup Texture"), _LightLookupTex);

                    if (_LightLookupTex.textureValue != null && _LightLookupTex.textureValue.wrapMode != TextureWrapMode.Clamp)
                        EditorGUILayout.HelpBox("Make sure texture uses 'Clamp' wrap mode.", MessageType.Warning);

                    materialEditor.ShaderProperty(_LightLookupOffset, "Bias");
                }
            }
        }
        }


        void DrawAlbedo(MaterialEditor materialEditor, Material material)
        {
            using (new EditorGUIHelper.EditorGUILayoutBeginVertical(EditorStyles.helpBox))
            {
                //Anchor
                EditorGUILayout.LabelField(string.Empty);
                Rect rect = GUILayoutUtility.GetLastRect();

                if (UnityEditor.EditorGUIUtility.isProSkin)
                    EditorGUI.DrawRect(new Rect(rect.xMin - 2, rect.yMin, rect.width + 4, rect.height), Color.white * 0.35f);


            EditorGUI.LabelField(rect, "Albedo", EditorStyles.boldLabel);
            using (new EditorGUIHelper.EditorGUIIndentLevel(1))
            {
                materialEditor.ShaderProperty(_IncludeVertexColor, "Vertex Color");
                materialEditor.ShaderProperty(_Color, "Tint Color");

                materialEditor.TexturePropertySingleLine(new GUIContent("Main Map"), _MainTex);
                using (new EditorGUIHelper.EditorGUIIndentLevel(1))
                {
                    materialEditor.TextureScaleOffsetProperty(_MainTex);
                    materialEditor.ShaderProperty(_MainTex_Scroll, string.Empty);
                }

                GUILayout.Space(10);
                materialEditor.ShaderProperty(_TextureMix, "Texture Blend");
                if (material.shaderKeywords.Contains("_TEXTUREMIX_BY_MAIN_ALPHA") ||
                    material.shaderKeywords.Contains("_TEXTUREMIX_BY_SECONDARY_ALPHA") ||
                    material.shaderKeywords.Contains("_TEXTUREMIX_MULTIPLE") || 
                    material.shaderKeywords.Contains("_TEXTUREMIX_ADDITIVE"))

                {
                    materialEditor.TexturePropertySingleLine(new GUIContent("Secondary Map"), _SecondaryTex);
                    using (new EditorGUIHelper.EditorGUIIndentLevel(1))
                    {
                        materialEditor.TextureScaleOffsetProperty(_SecondaryTex);
                        materialEditor.ShaderProperty(_SecondaryTex_Scroll, string.Empty);
                    }
                }
                else if (material.shaderKeywords.Contains("_TEXTUREMIX_BY_VERTEX_ALPHA"))
                {
                    materialEditor.ShaderProperty(_SecondaryTex_Blend, "Vertex Alpha Offset");
                    materialEditor.TexturePropertySingleLine(new GUIContent("Secondary Map"), _SecondaryTex);
                    using (new EditorGUIHelper.EditorGUIIndentLevel(1))
                    {
                        materialEditor.TextureScaleOffsetProperty(_SecondaryTex);
                        materialEditor.ShaderProperty(_SecondaryTex_Scroll, string.Empty);
                    }
                }
            }
        }
        }

        void DrawCutout(MaterialEditor materialEditor, Material material)
        {
            if (isOutline)
                return;


            if (material.shaderKeywords.Contains("_ALPHATEST_ON"))
            {
                using (new EditorGUIHelper.EditorGUILayoutBeginVertical(EditorStyles.helpBox))
                {
                    //Anchor
                    EditorGUILayout.LabelField(string.Empty);
                    Rect rect = GUILayoutUtility.GetLastRect();

                    if (UnityEditor.EditorGUIUtility.isProSkin)
                        EditorGUI.DrawRect(new Rect(rect.xMin - 2, rect.yMin, rect.width + 4, rect.height), Color.white * 0.35f);


                EditorGUI.LabelField(rect, "Cutout", EditorStyles.boldLabel);
                using (new EditorGUIHelper.EditorGUIIndentLevel(1))
                {
                    materialEditor.ShaderProperty(_Cutoff, "Alpha Cutoff");
                }
            }
        }
        }

        void DrawBumpMap(MaterialEditor materialEditor, Material material)
        {
            bool value = material.shaderKeywords.Contains("_NORMALMAP");

            using (new EditorGUIHelper.EditorGUILayoutBeginVertical(EditorStyles.helpBox))
            {
                //Anchor
                EditorGUILayout.LabelField(string.Empty);
                Rect rect = GUILayoutUtility.GetLastRect();

                if (UnityEditor.EditorGUIUtility.isProSkin)
                    EditorGUI.DrawRect(new Rect(rect.xMin - 2, rect.yMin, rect.width + 4, rect.height), Color.white * 0.35f);


            EditorGUI.BeginChangeCheck();
            value = EditorGUI.ToggleLeft(rect, "Bump", value, EditorStyles.boldLabel);
            if (EditorGUI.EndChangeCheck())
            {
                if (value)
                    material.EnableKeyword("_NORMALMAP");
                else
                    material.DisableKeyword("_NORMALMAP");
            }

            if (value)
            {
                using (new EditorGUIHelper.EditorGUIIndentLevel(1))
                {
                    materialEditor.ShaderProperty(_NormalMapStrength, "Strength");

                        GUILayout.Space(5);
                    materialEditor.TexturePropertySingleLine(new GUIContent("Normal Map"), _NormalMap);
                    using (new EditorGUIHelper.EditorGUIIndentLevel(1))
                    {
                            materialEditor.TextureScaleOffsetProperty(_NormalMap);
                            materialEditor.ShaderProperty(_NormalMap_Scroll, string.Empty);
                    }

                    if (material.shaderKeywords.Contains("_TEXTUREMIX_BY_MAIN_ALPHA") ||
                        material.shaderKeywords.Contains("_TEXTUREMIX_BY_SECONDARY_ALPHA") ||
                        material.shaderKeywords.Contains("_TEXTUREMIX_MULTIPLE") ||
                        material.shaderKeywords.Contains("_TEXTUREMIX_ADDITIVE") ||
                        material.shaderKeywords.Contains("_TEXTUREMIX_BY_VERTEX_ALPHA"))
                    {
                        materialEditor.TexturePropertySingleLine(new GUIContent("Secondary Normal Map"), _SecondaryNormalMap);
                        using (new EditorGUIHelper.EditorGUIIndentLevel(1))
                        {
                                materialEditor.TextureScaleOffsetProperty(_SecondaryNormalMap);
                                materialEditor.ShaderProperty(_SecondaryNormalMap_Scroll, string.Empty);
                            }
                        }
                    }
                }
            }
        }

        void DrawSpecular(MaterialEditor materialEditor, Material material)
        {
            bool value = material.shaderKeywords.Contains("_SPECULAR");
            using (new EditorGUIHelper.EditorGUILayoutBeginVertical(EditorStyles.helpBox))
            {
                //Anchor
                EditorGUILayout.LabelField(string.Empty);
                Rect rect = GUILayoutUtility.GetLastRect();

                if (UnityEditor.EditorGUIUtility.isProSkin)
                    EditorGUI.DrawRect(new Rect(rect.xMin - 2, rect.yMin, rect.width + 4, rect.height), Color.white * 0.35f);


            EditorGUI.BeginChangeCheck();
            value = EditorGUI.ToggleLeft(rect, "Specular", value, EditorStyles.boldLabel);
            if (EditorGUI.EndChangeCheck())
            {
                if (value)
                    material.EnableKeyword("_SPECULAR");
                else
                    material.DisableKeyword("_SPECULAR");
            }

            if (value)
            {
                using (new EditorGUIHelper.EditorGUIIndentLevel(1))
                {
                    materialEditor.ShaderProperty(_SpecularColor, "Color");
                    materialEditor.ShaderProperty(_Shininess, "Shininess");
                    materialEditor.ShaderProperty(_SpecularMaskOffset, "Mask Offset");
                }
            }
        }
        }

        void DrawReflection(MaterialEditor materialEditor, Material material)
        {
            bool value = material.shaderKeywords.Contains("_REFLECTION");

            using (new EditorGUIHelper.EditorGUILayoutBeginVertical(EditorStyles.helpBox))
            {
                //Anchor
                EditorGUILayout.LabelField(string.Empty);
                Rect rect = GUILayoutUtility.GetLastRect();

                if (UnityEditor.EditorGUIUtility.isProSkin)
                    EditorGUI.DrawRect(new Rect(rect.xMin - 2, rect.yMin, rect.width + 4, rect.height), Color.white * 0.35f);


            EditorGUI.BeginChangeCheck();
            value = EditorGUI.ToggleLeft(rect, "Reflection", value, EditorStyles.boldLabel);
            if (EditorGUI.EndChangeCheck())
            {
                if (value)
                    material.EnableKeyword("_REFLECTION");
                else
                    material.DisableKeyword("_REFLECTION");
            }

            if (value)
            {
                using (new EditorGUIHelper.EditorGUIIndentLevel(1))
                {
                    materialEditor.ShaderProperty(_ReflectionColor, "Color");
                    materialEditor.ShaderProperty(_ReflectionMaskOffset, "Mask Offset");
                    materialEditor.TexturePropertySingleLine(new GUIContent("CubeMap"), _ReflectionCubeMap);
                    materialEditor.ShaderProperty(_ReflectionFresnelBias, "Fresnel Bias");
                }
            }
        }
        }

        void DrawRimFresnel(MaterialEditor materialEditor, Material material)
        {
            bool value = material.shaderKeywords.Contains("_RIM");

            using (new EditorGUIHelper.EditorGUILayoutBeginVertical(EditorStyles.helpBox))
            {
                //Anchor
                EditorGUILayout.LabelField(string.Empty);
                Rect rect = GUILayoutUtility.GetLastRect();

                if (UnityEditor.EditorGUIUtility.isProSkin)
                    EditorGUI.DrawRect(new Rect(rect.xMin - 2, rect.yMin, rect.width + 4, rect.height), Color.white * 0.35f);


            EditorGUI.BeginChangeCheck();
            value = EditorGUI.ToggleLeft(rect, "Rim/Fresnel", value, EditorStyles.boldLabel);
            if (EditorGUI.EndChangeCheck())
            {
                if (value)
                    material.EnableKeyword("_RIM");
                else
                    material.DisableKeyword("_RIM");
            }

            if (value)
            {
                using (new EditorGUIHelper.EditorGUIIndentLevel(1))
                {
                    materialEditor.ShaderProperty(_RimColor, "Color");
                    materialEditor.ShaderProperty(_RimBias, "Bias");
                }
            }
        }
        }

        void DrawEmission(MaterialEditor materialEditor, Material material)
        {
            bool value = material.shaderKeywords.Contains("_EMISSION");

            using (new EditorGUIHelper.EditorGUILayoutBeginVertical(EditorStyles.helpBox))
            {
                //Anchor
                EditorGUILayout.LabelField(string.Empty);
                Rect rect = GUILayoutUtility.GetLastRect();

                if (UnityEditor.EditorGUIUtility.isProSkin)
                    EditorGUI.DrawRect(new Rect(rect.xMin - 2, rect.yMin, rect.width + 4, rect.height), Color.white * 0.35f);


            EditorGUI.BeginChangeCheck();
            value = EditorGUI.ToggleLeft(rect, "Emission", value, EditorStyles.boldLabel);
            if (EditorGUI.EndChangeCheck())
            {
                if (value)
                    material.EnableKeyword("_EMISSION");
                else
                    material.DisableKeyword("_EMISSION");
            }

            if (value)
            {
                using (new EditorGUIHelper.EditorGUIIndentLevel(1))
                {
                        materialEditor.TexturePropertySingleLine(new GUIContent("Emission Map"), _EmissionMap, _EmissionColor);
                    using (new EditorGUIHelper.EditorGUIIndentLevel(1))
                    {
                            materialEditor.TextureScaleOffsetProperty(_EmissionMap);
                            materialEditor.ShaderProperty(_EmissionMap_Scroll, string.Empty);
                        }
                    }
                }
            }
        }

        void DrawOutline(MaterialEditor materialEditor, Material material)
        {
            if (_OutlineColor == null)
                return;

            using (new EditorGUIHelper.EditorGUILayoutBeginVertical(EditorStyles.helpBox))
            {
                //Anchor
                EditorGUILayout.LabelField(string.Empty);
                Rect rect = GUILayoutUtility.GetLastRect();

                if (UnityEditor.EditorGUIUtility.isProSkin)
                    EditorGUI.DrawRect(new Rect(rect.xMin - 2, rect.yMin, rect.width + 4, rect.height), Color.white * 0.35f);


            EditorGUI.LabelField(rect, "Outline", EditorStyles.boldLabel);
            using (new EditorGUIHelper.EditorGUIIndentLevel(1))
            {
                materialEditor.ShaderProperty(_OutlineColor, "Color");
                materialEditor.ShaderProperty(_OutlineWidth, "Width");
                materialEditor.ShaderProperty(_OutlineSizeIsFixed, "Fixed Size");
            }
        }
        }


        void DrawHeader(string label)
        {
            Rect headerRect = EditorGUILayout.GetControlRect();
            EditorGUI.DrawRect(new Rect(0, headerRect.yMin, headerRect.width + headerRect.xMin, headerRect.height), UnityEditor.EditorGUIUtility.isProSkin ? Color.black * 0.5f : Color.white * 0.825f);
            EditorGUI.DrawRect(new Rect(0, headerRect.yMin, headerRect.width + headerRect.xMin, 1), Color.black * 0.2f);

            EditorGUI.LabelField(new Rect(headerRect.xMin, headerRect.yMin, headerRect.width, headerRect.height), label, EditorStyles.boldLabel);
        }
        void FindProperties(MaterialProperty[] properties)
        {
            _AmbientLights = CurvedWorldEditor.MaterialProperties.FindProperty("_AmbientLights", properties, true);
            _PerVertexLights = CurvedWorldEditor.MaterialProperties.FindProperty("_PerVertexLights", properties, true);

            _LightLookupTex = CurvedWorldEditor.MaterialProperties.FindProperty("_LightLookupTex", properties, true);
            _LightLookupOffset = CurvedWorldEditor.MaterialProperties.FindProperty("_LightLookupOffset", properties, true);

            _IncludeVertexColor = CurvedWorldEditor.MaterialProperties.FindProperty("_IncludeVertexColor", properties, true);
            _Color = CurvedWorldEditor.MaterialProperties.FindProperty("_Color", properties, true);
            _MainTex = CurvedWorldEditor.MaterialProperties.FindProperty("_MainTex", properties, true);
            _MainTex_Scroll = CurvedWorldEditor.MaterialProperties.FindProperty("_MainTex_Scroll", properties, true);
            _Cutoff = CurvedWorldEditor.MaterialProperties.FindProperty("_Cutoff", properties, true);

            _TextureMix = CurvedWorldEditor.MaterialProperties.FindProperty("_TextureMix", properties, true);
            _SecondaryTex = CurvedWorldEditor.MaterialProperties.FindProperty("_SecondaryTex", properties, true);
            _SecondaryTex_Scroll = CurvedWorldEditor.MaterialProperties.FindProperty("_SecondaryTex_Scroll", properties, true);
            _SecondaryTex_Blend = CurvedWorldEditor.MaterialProperties.FindProperty("_SecondaryTex_Blend", properties, true);

            _NormalMapStrength = CurvedWorldEditor.MaterialProperties.FindProperty("_NormalMapStrength", properties, true);
            _NormalMap = CurvedWorldEditor.MaterialProperties.FindProperty("_NormalMap", properties, true);
            _NormalMap_Scroll = CurvedWorldEditor.MaterialProperties.FindProperty("_NormalMap_Scroll", properties, true);
            _SecondaryNormalMap = CurvedWorldEditor.MaterialProperties.FindProperty("_SecondaryNormalMap", properties, true);
            _SecondaryNormalMap_Scroll = CurvedWorldEditor.MaterialProperties.FindProperty("_SecondaryNormalMap_Scroll", properties, true);

            _SpecularColor = CurvedWorldEditor.MaterialProperties.FindProperty("_SpecularColor", properties, true);
            _Shininess = CurvedWorldEditor.MaterialProperties.FindProperty("_Shininess", properties, true);
            _SpecularMaskOffset = CurvedWorldEditor.MaterialProperties.FindProperty("_SpecularMaskOffset", properties, true);

            _ReflectionColor = CurvedWorldEditor.MaterialProperties.FindProperty("_ReflectionColor", properties, true);
            _ReflectionMaskOffset = CurvedWorldEditor.MaterialProperties.FindProperty("_ReflectionMaskOffset", properties, true);
            _ReflectionCubeMap = CurvedWorldEditor.MaterialProperties.FindProperty("_ReflectionCubeMap", properties, true);
            _ReflectionFresnelBias = CurvedWorldEditor.MaterialProperties.FindProperty("_ReflectionFresnelBias", properties, true);

            _RimColor = CurvedWorldEditor.MaterialProperties.FindProperty("_RimColor", properties, true);
            _RimBias = CurvedWorldEditor.MaterialProperties.FindProperty("_RimBias", properties, true);

            _EmissionColor = CurvedWorldEditor.MaterialProperties.FindProperty("_EmissionColor", properties, true);
            _EmissionMap = CurvedWorldEditor.MaterialProperties.FindProperty("_EmissionMap", properties, true);
            _EmissionMap_Scroll = CurvedWorldEditor.MaterialProperties.FindProperty("_EmissionMap_Scroll", properties, true);


            //Available only in Outline shader
            _OutlineColor = CurvedWorldEditor.MaterialProperties.FindProperty("_OutlineColor", properties, false);
            _OutlineWidth = CurvedWorldEditor.MaterialProperties.FindProperty("_OutlineWidth", properties, false);
            _OutlineSizeIsFixed = CurvedWorldEditor.MaterialProperties.FindProperty("_OutlineSizeIsFixed", properties, false);
        }
    }
}