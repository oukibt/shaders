using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(VHSEffect))]
[CanEditMultipleObjects]
public class VHSEffectEditor : Editor
{
    SerializedProperty m_TapeNoise_Enabled;
    SerializedProperty m_TapeNoise_Color;
    SerializedProperty m_TapeNoise_GrainSize;
    SerializedProperty m_TapeNoise_Amount;
    SerializedProperty m_TapeNoise_Power;
    SerializedProperty m_TapeNoise_Speed;

    SerializedProperty m_LineNoise_Enabled;
    SerializedProperty m_LineNoise_Size;
    SerializedProperty m_LineNoise_Power;
    SerializedProperty m_LineNoise_XPower;
    SerializedProperty m_LineNoise_Speed;
    SerializedProperty m_LineNoise_Delay;

    //

    SerializedObject so;

    void OnEnable()
    {
        so = new SerializedObject(target);

        m_TapeNoise_Enabled = so.FindProperty("m_TapeNoise_Enabled");
        m_TapeNoise_Color = so.FindProperty("m_TapeNoise_Color");
        m_TapeNoise_GrainSize = so.FindProperty("m_TapeNoise_GrainSize");
        m_TapeNoise_Amount = so.FindProperty("m_TapeNoise_Amount");
        m_TapeNoise_Power = so.FindProperty("m_TapeNoise_Power");
        m_TapeNoise_Speed = so.FindProperty("m_TapeNoise_Speed");

        m_LineNoise_Enabled = so.FindProperty("m_LineNoise_Enabled");
        m_LineNoise_Size = so.FindProperty("m_LineNoise_Size");
        m_LineNoise_Power = so.FindProperty("m_LineNoise_Power");
        m_LineNoise_XPower = so.FindProperty("m_LineNoise_XPower");
        m_LineNoise_Speed = so.FindProperty("m_LineNoise_Speed");
        m_LineNoise_Delay = so.FindProperty("m_LineNoise_Delay");
    }

    public override void OnInspectorGUI()
    {
        so.Update();

        GUIStyle gui = new GUIStyle(EditorStyles.foldout);
        gui.fontStyle = FontStyle.Bold;

        //

        m_TapeNoise_Enabled.boolValue = EditorGUILayout.Toggle("Use Tape Noise", m_TapeNoise_Enabled.boolValue);
        if (m_TapeNoise_Enabled.boolValue)
        {
            StartFields();

            m_TapeNoise_Color.colorValue = EditorGUILayout.ColorField(m_TapeNoise_Color.colorValue);
            m_TapeNoise_GrainSize.floatValue = EditorGUILayout.Slider("Grain Size", m_TapeNoise_GrainSize.floatValue, 0.0f, 1.0f);
            m_TapeNoise_Amount.floatValue = EditorGUILayout.Slider("Amount", m_TapeNoise_Amount.floatValue, 0.0f, 1.0f);
            m_TapeNoise_Power.floatValue = EditorGUILayout.Slider("Power", m_TapeNoise_Power.floatValue, 0.0f, 1.0f);
            m_TapeNoise_Speed.floatValue = EditorGUILayout.Slider("Speed", m_TapeNoise_Speed.floatValue, 0.0f, 20.0f);

            EndFields();

            EditorGUILayout.Space();
        }

        //

        m_LineNoise_Enabled.boolValue = EditorGUILayout.Toggle("Use Line Noise", m_LineNoise_Enabled.boolValue);
        if (m_LineNoise_Enabled.boolValue)
        {
            StartFields();

            m_LineNoise_Size.floatValue = EditorGUILayout.Slider("Size", m_LineNoise_Size.floatValue, 0.0f, 1.0f);
            m_LineNoise_Power.floatValue = EditorGUILayout.Slider("Power", m_LineNoise_Power.floatValue, 1.0f, 8.0f);
            m_LineNoise_XPower.floatValue = EditorGUILayout.Slider("XPower", m_LineNoise_XPower.floatValue, 0.0f, 0.1f);
            m_LineNoise_Speed.floatValue = EditorGUILayout.Slider("Speed", m_LineNoise_Speed.floatValue, 0.0f, 4.0f);
            m_LineNoise_Delay.floatValue = EditorGUILayout.FloatField("Delay", m_LineNoise_Delay.floatValue);

            EndFields();

            EditorGUILayout.Space();
        }

        //

        so.ApplyModifiedProperties();
    }

    private void StartFields()
    {
        EditorGUI.indentLevel++;
    }

    private void EndFields()
    {
        EditorGUI.indentLevel--;
    }
}
